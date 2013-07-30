Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:4556 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3G3TE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 15:04:26 -0400
Date: Tue, 30 Jul 2013 19:02:29 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
To: Josef Bacik <jbacik@fusionio.com>, Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
In-Reply-To: <20130730171329.GF24583@localhost.localdomain>
Message-ID: <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg> <20130730171329.GF24583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik dixit:

>Can you gdb btrfs.ko and do
>
>list *(__btrfs_map_block+0x11c)

Not easily (the kernel image is from a .deb package),
and even in a compile tree gdb just says:
No symbol table is loaded.  Use the "file" command.

With a bit of cheating and a cross-compiler, this is:

(gdb) list *0x0000106e
0x106e is in __btrfs_map_block (/var/lib/gforge/chroot/home/users/tg/Xl/linux-3.10.1/fs/btrfs/volumes.c:4447).
4442            stripe_nr = offset;
4443            /*
4444             * stripe_nr counts the total number of stripes we have to stride
4445             * to get to this block
4446             */
4447            do_div(stripe_nr, stripe_len);
4448
4449            stripe_offset = stripe_nr * stripe_len;
4450            BUG_ON(offset < stripe_offset);
4451

The code is somewhat matching:

   0x00001062 <+268>:   movel %fp@(-140),%d1
   0x00001066 <+272>:   movel %fp@(-164),%d5
   0x0000106a <+276>:   movel %fp@(-160),%d6
   0x0000106e <+280>:   divul %d5,%d2,%d1
   0x00001072 <+284>:   movel %d0,%fp@(-156)
   0x00001076 <+288>:   movel %d1,%fp@(-152)
   0x0000107a <+292>:   movel %d5,%d1
   0x0000107c <+294>:   mulsl %fp@(-152),%d1
   0x00001082 <+300>:   mulsl %d4,%d0
   0x00001086 <+304>:   moveal %d1,%a0
   0x00001088 <+306>:   addal %d0,%a0
   0x0000108a <+308>:   movel %d6,%d1
   0x0000108c <+310>:   mulul %fp@(-152),%d0,%d1

According to the registers…

 [   38.800000] d0: 00000000    d1: 00001000    d2: 00000000    d3: 00000000
 [   38.830000] d4: 00010000    d5: 00000000    a0: 3085c72c    a1: 3085c72c

… this is (if I parse this right) 0000000000001000 / 00000000
(64-bit D2:D1 divided by 32-bit D5 store into D1, remainder into D2).


Joe Perches dixit quod…

> do_div seems a likely suspect...

I do admit I don’t understand arch/m68k/include/asm/div64.h
being not a real m68k coder, but “it works elsewhere”…

(And I loathe GCC inline asm with a passion!)

>From the code expansion, I assume (__upper = __n.n32[0]) is
always zero (as we get only one divul instruction). This looks
a bit weird because the numbers in question are all 64 bit
(stripe_nr, offset, logical).


Hm, actually… from a test program…

#include <stdio.h>

typedef unsigned long long u64;

int main(void)
{
 u64 stripe_nr;
 u64 stripe_len;

 stripe_nr = 1234;
 stripe_len = 2;
 printf("in : %llu / %llu\n", stripe_nr, stripe_len);

 ({ union { unsigned long n32[2]; unsigned long long n64; } __n; unsigned long __rem, __upper; __n.n64 = (stripe_nr); if ((__upper = __n.n32[0])) { asm ("divul.l %2,%1:%0" : "=d" (__n.n32[0]), "=d" (__upper) : "d" (stripe_len), "0" (__n.n32[0])); } asm ("divu.l %2,%1:%0" : "=d" (__n.n32[1]), "=d" (__rem) : "d" (stripe_len), "1" (__upper), "0" (__n.n32[1])); (stripe_nr) = __n.n64; __rem; });

 printf("out: %llu R %llu\n", stripe_nr, stripe_len);
 return (0);
}

… I think we get two divul instructions, just with a lot
of moves between them. Hmpf. The frame pointer would be
useful to know, to know the proper values used for these
operations…


… Aaaah okay. Some reading *(gdb.info):: later, indeed:

(gdb) info line 4446
Line 4446 of "/var/lib/gforge/chroot/home/users/tg/Xl/linux-3.10.1/fs/btrfs/volumes.c"
   is at address 0x104a <__btrfs_map_block+244> but contains no code.
(gdb) info line 4448
Line 4448 of "/var/lib/gforge/chroot/home/users/tg/Xl/linux-3.10.1/fs/btrfs/volumes.c"
   is at address 0x107a <__btrfs_map_block+292> but contains no code.
(gdb) disas /r 0x104a,0x107a
Dump of assembler code from 0x104a to 0x107a:
   0x0000104a <__btrfs_map_block+244>:  20 02   movel %d2,%d0
   0x0000104c <__btrfs_map_block+246>:  24 2e ff 70     movel %fp@(-144),%d2
   0x00001050 <__btrfs_map_block+250>:  4a 80   tstl %d0
   0x00001052 <__btrfs_map_block+252>:  67 0e   beqs 0x1062 <__btrfs_map_block+268>
   0x00001054 <__btrfs_map_block+254>:  20 02   movel %d2,%d0
   0x00001056 <__btrfs_map_block+256>:  2c 2e ff 5c     movel %fp@(-164),%d6
   0x0000105a <__btrfs_map_block+260>:  2e 2e ff 60     movel %fp@(-160),%d7
   0x0000105e <__btrfs_map_block+264>:  4c 46 00 02     divull %d6,%d2,%d0
   0x00001062 <__btrfs_map_block+268>:  22 2e ff 74     movel %fp@(-140),%d1
   0x00001066 <__btrfs_map_block+272>:  2a 2e ff 5c     movel %fp@(-164),%d5
   0x0000106a <__btrfs_map_block+276>:  2c 2e ff 60     movel %fp@(-160),%d6
   0x0000106e <__btrfs_map_block+280>:  4c 45 14 02     divul %d5,%d2,%d1
   0x00001072 <__btrfs_map_block+284>:  2d 40 ff 64     movel %d0,%fp@(-156)
   0x00001076 <__btrfs_map_block+288>:  2d 41 ff 68     movel %d1,%fp@(-152)
End of assembler dump.

Now, can anyone more fluent in m68k asm make out a problem with it?

bye,
//mirabilos
-- 
I believe no one can invent an algorithm. One just happens to hit upon it
when God enlightens him. Or only God invents algorithms, we merely copy them.
If you don't believe in God, just consider God as Nature if you won't deny
existence.		-- Coywolf Qi Hunt

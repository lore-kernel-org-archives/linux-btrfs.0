Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:28301 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3HWJJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:09:27 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 23 Aug 2013 10:09:24 +0100
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Message-ID: <CE3CE512.3C43A%mark@backupsystems.co.uk>
In-Reply-To: <kv74sk$bg9$1@ger.gmane.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The speed improvement for dumping large databases through samba with
strict allocate = yes to BTRFS was amazing.  It reduced a 1 hour dump down
to 20 minutes.

On 23/08/2013 09:01, "Roger Binns" <rogerb@rogerbinns.com> wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>On 22/08/13 07:07, Josef Bacik wrote:
>> Not sure what strict allocate = yes does,
>
>I've worked on SMB servers before and can answer that.  Historically the
>way Windows apps (right back into the 16 bit days) have made sure there is
>space for a file about to be written is to ask the OS to allocate all the
>space for it.  (Unix by default leaves holes making a sparse file.)
>
>For example if a 10MB file is going to be written then an allocation will
>be done of 10MB.  (The exact underlying protocol commands vary, but
>originally were similar to the Unix seek to end and write.)  After that
>seeks and writes are done.  Because the allocation succeeded the app knows
>that it won't get an out of space error.
>
>Separately from that, it turns out that some filesystems do benefit from
>preallocating the file to the expected size, and then writing the contents
>in dribs and drabs into the allocated space.
>
>Consequently Samba gives you the option of really allocating all the file,
>either for Windows semantics compatibility, or because it results in
>improved performance on the Unix filesystem.
>
>However I can't see it being of any benefit on a COW filesystem like
>btrfs.
>
>Roger
>
>
>
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.12 (GNU/Linux)
>
>iEYEARECAAYFAlIXFtsACgkQmOOfHg372QR7cwCggRyQxtxj9E7dNKV94M/Tv5o6
>LC0AoN9icJNVxzkV0kDQSgf3Vt0N3g3V
>=wBHz
>-----END PGP SIGNATURE-----
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


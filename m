From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: Restoring BTRFS partition
Date: Tue, 20 Apr 2010 23:55:38 +0800
Message-ID: <20100420155538.GB3634@laptop.oracle.com>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alli Quaknaa <alquaknaa@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi al-Quaknaa,

I guess the reason is that the 300M file btrfs and the one on your
partition have different block size. Thus 65k zeros on your file image
doesn't mean 65k on the partition. So maybe you will try with blocks
instead of bytes.

The man page for mkfs.btrfs is bad for having no description about what
will be going on if an option(-s this case) is not provided. A fix block
size such as 1k, 4k or calculated per the partition(s) size.

thanks,
wengang.

On 10-04-20 16:56, Alli Quaknaa wrote:
> Hello,
> Yesterday I have messed up my partition table and lost the information
> of my BTRFS partition. Luckily I was able to find it's beginning, or
> at least I think so. This is what I did:
> - created a blank 300M file, formated with btrfs, examined with
> hexedit. After 65536 zeros (at the position 0x10000) a sequence "1F 55
> A8 7C" comes and at a position 0x10040 an ASCII sequence _BHRfS_M_ is
> found.
> - I found the same sequence ("_BHRfS_M_") in the raw image of my drive
> and I've made another image to make my original look more like the
> 300M file - so in the beginning 65k of zeros and the sequence
> _BHRfS_M_ is at the same position (basically I just deleted whatever
> was before this sequence and prepended those zeros).
> 
> I don't think I have done anything that could have damaged the
> filesystem itself and when viewing with hexedit I still see ELF data,
> include files and so on, but I can't get the new image to mount or
> btrfsck, it is simply not recognized as a btrfs image. Could anyone
> please help me fix this? I have very little actual C/Linux knowledge
> (from the programmers point of view) so I'd rather not go reading the
> code.
> 
> Of course I can send whatever more information you need, just as a
> starter - I have no idea what the sequence at 0x10000 is, but it is
> different than the one of my blank 300M file - in my partition it says
> "CB EE AE 02".
> 
> Thanks in advance,
> al-Quaknaa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

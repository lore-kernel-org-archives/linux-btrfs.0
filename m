From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: csum errors
Date: Thu, 15 Jul 2010 21:32:12 +0200
Message-ID: <201007152132.13701.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de> <20100715190309.GI8623@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100715190309.GI8623@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 15 Juli 2010, 21:03:09 schrieb Chris Mason:
> On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
> > Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
> > > ino 1959333 off 898342912 csum 4271223884 private 4271223883
> > 
> > I think, this is a different error. I've only seen them on filesystems
> > from my Opteron system. It seems that the recorded csums are wrong and
> > it looks to me like rounding errors. The data itself should be correct,
> > as I've tested one affected file via md5sum against the original on
> > another filesystem. Any ideas what is going wrong here?
> 
> Are you doing data mirroring?

No, I don't.

> We can map that block and do a raw read off the device to see what the
> data blocks actually contain.

I've modified the btrfs-source a little to get the data. In inode.c I've 
changed the code to:


        csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
        btrfs_csum_final(csum, (char *)&csum);
        if (csum != private)
                if (printk_ratelimit()) {
                        printk(KERN_INFO "csum != private; ino %lu off %llu "
                        "csum %u private %llu\n", page->mapping->host->i_ino,
                        (unsigned long long)start, csum,
                        (unsigned long long)private);
                }
                // goto zeroit;

        kunmap_atomic(kaddr, KM_USER0);

This way I could read the files with wrong csum too. As I wrote, I've compared 
the md5sum from one file with a copy on an other filesystem. As they are the 
same, at least for this file the data should be correct. The big question is, 
why do the csums differ?

regards,
  Johannes

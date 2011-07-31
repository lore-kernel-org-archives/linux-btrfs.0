From: CACook@quantum-sci.com
Subject: Re: Emergency - Can't Boot
Date: Sat, 30 Jul 2011 21:16:55 -0700
Message-ID: <201107302116.56007.CACook@quantum-sci.com>
References: <1312055511.4346.9.camel@hydra.darkmatter.org> <201107301412.46941.CACook@quantum-sci.com> <CAG1y0scsFnWV+YcSzg=YAR82bLvce-UyK+LvEfeORhpYPWe8ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scsFnWV+YcSzg=YAR82bLvce-UyK+LvEfeORhpYPWe8ew@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 30 July, 2011 19:34:26 Fajar A. Nugraha wrote:
> IMHO a better fix is to just disable fsck on fstab for that fs. Something like
> 
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> LABEL=ROOT  /               btrfs
> subvolid=258,compress-force=lzo,noatime        0       0

I've done that too.


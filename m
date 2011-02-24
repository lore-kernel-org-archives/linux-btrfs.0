From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Thu, 24 Feb 2011 10:23:12 -0500
Message-ID: <1298560914-sup-7112@think>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <1865303E0DED764181A9D882DEF65FB6864AE1B667@shsmsx502.ccr.corp.intel.com> <1298498150-sup-7270@think> <201102240002.45682.johannes.hirte@fem.tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Cc: "Zhong, Xin" <xin.zhong@intel.com>,
	=?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201102240002.45682.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Johannes Hirte's message of 2011-02-23 18:02:44 -0500:
> On Wednesday 23 February 2011 22:56:27 Chris Mason wrote:
> > Excerpts from Zhong, Xin's message of 2011-02-23 02:27:05 -0500:
> > > In the dmesg of rc4, I can see svn hang in shrink_dellalloc and there's
> > > two flush-btrfs threads hang there too.
> > > 
> > > Josef, it seems you are the expert in this area. Could you take a quick
> > > look? Thanks!
> > 
> > Ok, it does look like the fluhs-btrfs threads are busy trying to flush
> > things.
> > 
> > Could you please do a btrfs-show and a btrfs fi df /xxx (where xxx is
> > your mount point) and send the results here?
> > 
> > -chris
> 
> failed to read /dev/sr0
> Label: none  uuid: 00eab15f-c4cf-4403-a529-9bc11fa50167
>         Total devices 1 FS bytes used 47.72GB
>         devid    1 size 65.69GB used 65.69GB path /dev/sda2
> 
> Label: none  uuid: c6f4e6e6-c4ba-4394-9e9c-bbc3d0b32793
>         Total devices 1 FS bytes used 9.48GB
>         devid    1 size 20.01GB used 20.01GB path /dev/sda1
> 
> Btrfs v0.19-35-g1b444cd-dirty
> 
> and btrfs fi df on
> 
> /
> 
> Data: total=15.49GB, used=8.35GB
> System, DUP: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=2.25GB, used=1.13GB
> 
> /home
> 
> Data: total=63.42GB, used=47.47GB
> System: total=4.00MB, used=16.00KB
> Metadata: total=2.27GB, used=251.34MB
> 
> The bug is reproducable on both filesystems.

Ok, you've got a good amount of metadata space free, but it is
frantically trying to make room for the delayed allocation.  Let me see
if I can recreate this setup here.

-chris

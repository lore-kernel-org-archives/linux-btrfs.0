From: Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Wed, 23 Feb 2011 16:56:27 -0500
Message-ID: <1298498150-sup-7270@think>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <201102020034.43808.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com> <201102222327.04621.johannes.hirte@fem.tu-ilmenau.de> <1865303E0DED764181A9D882DEF65FB6864AE1B667@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	=?utf-8?q?Maria_Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1865303E0DED764181A9D882DEF65FB6864AE1B667@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Zhong, Xin's message of 2011-02-23 02:27:05 -0500:
> In the dmesg of rc4, I can see svn hang in shrink_dellalloc and there's two flush-btrfs threads hang there too.
> 
> Josef, it seems you are the expert in this area. Could you take a quick look? Thanks!

Ok, it does look like the fluhs-btrfs threads are busy trying to flush
things.

Could you please do a btrfs-show and a btrfs fi df /xxx (where xxx is
your mount point) and send the results here?

-chris

> 
> -----Original Message-----
> From: Johannes Hirte [mailto:johannes.hirte@fem.tu-ilmenau.de] 
> Sent: Wednesday, February 23, 2011 6:27 AM
> To: Zhong, Xin
> Cc: Maria Wikstr\xc3\xb6m; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
> 
> On Friday 11 February 2011 05:39:39 Zhong, Xin wrote:
> > Hi,
> > 
> > Could you paste the output of sysrq+t here? Thanks!
> 
> Sorry for the long delay. I've attached the dmesg output of sysrq-t from
> 2.6.38-rc3 and rc4 as the behavior differs between both versions. With rc3 it don't need any interaction. I start 'emerge sys-devel/libgcrypt', the tasks hangs and top shows a svn process eating 100% CPU. With rc4 the system hangs too but the CPU load stays low. When I try to cancel the emerge process (ctrl
> c) the CPU load goes up and top shows the svn process together with a flush- btrfs task, eating the CPU.
> \xff\xf4\xe8\xba{.n\xc7+\x89\xb7\x9f\xae\x89\xad\x86+%\x8a\xcb\xff\xb1\xe9\xdd\xb6\xa5\x8aw\xff\xba{.n\xc7+\x89\xb7\xa5\x8a{\xb1\xfd\xbbk~\xcf\xe2\x9e\xd8^n\x87r\xa1\xf6\xa6z\xcb\x81\xebh\x99\xa8\xe8\xad\xda&\xa3\xfb\xe0z\xbf\xe4z\xb9\xde\x97\xfa+\x80\xca+zf\xa3\xa2\xb7h\x9a\x88\xa7~\x86\xad\x86\xdbi\xff\xff\xef\x81\xea\xff\x91\xea\xe7z_\xe8\xae\xe6j:+v\x89\xa8\xfe)\xdf\xa3\xf8m

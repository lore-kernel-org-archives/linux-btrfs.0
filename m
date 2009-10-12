From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 08:47:26 -0400
Message-ID: <20091012124726.GL2632@think>
References: <4A74401B.90801@mccme.ru>
 <20090803145741.GC3765@think>
 <4A76FB78.5000207@wpkg.org>
 <20090803235920.C13173@mccme.ru>
 <87my3y3r8u.fsf@faran.nsc.liu.se>
 <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
 <4AD2E3CF.6080701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng " <yanzheng@21cn.com>,
	=?iso-8859-1?B?UORy?= Andersson <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD2E3CF.6080701@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2009 at 10:07:43AM +0200, Tomasz Chmielewski wrote:
> Yan, Zheng wrote:
> 
> >>What is the reason for the limit, and is there any chance of increasing
> >>it to something more reasonable as Mikhail suggested?
> >
> >The limit is imposed by the format of inode back references. We can
> >get rid of the limit, but it requires a disk format change.
> 
> Please do get rid of this limit, it's ridiculously small.
> 
> Of course, not necessarily right now, but when you introduce some
> other changes needing disk format change, please think of removing
> the hard link limit as well.

Please keep in mind this is only a limit on the number of links to a
single file where the links and the file are all in the same directory.

-chris

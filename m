From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 10:07:43 +0200
Message-ID: <4AD2E3CF.6080701@wpkg.org>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>	 <4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>	 <87my3y3r8u.fsf@faran.nsc.liu.se> <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: =?ISO-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>,
	linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:

>> What is the reason for the limit, and is there any chance of increasing
>> it to something more reasonable as Mikhail suggested?
> 
> The limit is imposed by the format of inode back references. We can
> get rid of the limit, but it requires a disk format change.

Please do get rid of this limit, it's ridiculously small.

Of course, not necessarily right now, but when you introduce some other 
changes needing disk format change, please think of removing the hard 
link limit as well.


-- 
Tomasz Chmielewski
http://wpkg.org


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63256 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966155Ab3HHTJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 15:09:06 -0400
Received: from [192.168.77.59] ([91.64.181.223]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LtmK9-1W7gWQ3e9l-0118RJ for
 <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 21:09:04 +0200
Message-ID: <5203ED45.3090604@gmx.net>
Date: Thu, 08 Aug 2013 21:11:01 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: dsterba@suse.cz, Sergei Trofimovich <slyich@gmail.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
References: <1375911803-17318-1-git-send-email-slyich@gmail.com> <1375911803-17318-7-git-send-email-slyich@gmail.com> <520349BA.8080006@gmx.net> <20130808132614.GS5284@twin.jikos.cz> <20130808174657.GV12314@lenny.home.zabbo.net>
In-Reply-To: <20130808174657.GV12314@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/13 19:46, Zach Brown wrote:
>>> even though the function is currently unused, I'm hesitating to remove it
>>> as it's part of the reada-API and might be handy for anyone going to use
>>> the API in the future.
>>
>> I agree. As replied here,
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html
>> please keep the function.
> 
> If we're keeping score, put me down for being in favour of removing dead
> untested code.  git ressurection is easy. 

It's not really untested, it has been in use some time ago. But of
course there's a chance that some changes broke it.
Yes, git ressurection is easy. To inform potential users, you might
just leave a comment like this:

/*
 * There has been a function once to detach from a running reada.
 * If you need such functionality, just revert the commit that
 * added this comment.
 */

-Arne

> 
> - z
> 


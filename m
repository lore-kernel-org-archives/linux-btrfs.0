Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:56460 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755485Ab3ECT0E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 15:26:04 -0400
Message-ID: <51840F54.9060206@sgi.com>
Date: Fri, 3 May 2013 14:26:12 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com> <51840047.4020908@sgi.com> <20130503190514.GD12414@localhost.localdomain>
In-Reply-To: <20130503190514.GD12414@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2013 02:05 PM, Josef Bacik wrote:
> On Fri, May 03, 2013 at 12:21:59PM -0600, Rich Johnston wrote:
>> Thanks for another patch Josef, it has been committed with the change
>> discussed.
>>
>
> Err I forgot to point out I already have a "sync" variable in there so it fails
> to compile, we'll need to change the var to do_sync or something.  Want me to
> send a patch along?  Thanks,
>
> Josef
>
Sorry this was my fault, I have reverted


commit 7f622f44b651aec13b99ef62c2942388a6fbee5d
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Fri May 3 14:07:59 2013 -0500

     Revert "xfstests 311: test fsync with dm flakey V3"

and committed it again.

commit dd3b5268312e0518ae695e8ee2a618f13805c425
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Apr 26 19:13:59 2013 +0000

     xfstests 311: test fsync with dm flakey V4


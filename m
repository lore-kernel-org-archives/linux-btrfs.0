Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:58648 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab3FINjy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Jun 2013 09:39:54 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.115])
	by atl4mhob15.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r59Ddspt023031
	for <linux-btrfs@vger.kernel.org>; Sun, 9 Jun 2013 09:39:54 -0400
Message-ID: <51B485B0.2080803@chinilu.com>
Date: Sun, 09 Jun 2013 06:40:00 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Possible solution to the "open_ctree" boot bug ...
References: <51AB5A76.9060203@chinilu.com> <vn978a-io2.ln1@hurikhan.ath.cx> <51B11FB5.4020207@chinilu.com> <CAMthOuPif30y4JPrNGhnUteajkck65FjwTss0vVFvCs7EM+gvQ@mail.gmail.com>
In-Reply-To: <CAMthOuPif30y4JPrNGhnUteajkck65FjwTss0vVFvCs7EM+gvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2013 01:24 AM, Kai Krakow wrote:
>
> Actually it should be called "rootdelay"... My fault...
>

Thanks again,  I have added it, will see what happens, I am looking for 
anything that might help at this point, so I am very appreciative!  - George


> Am 07.06.2013 01:48 schrieb "George Mitchell" <george@chinilu.com 
> <mailto:george@chinilu.com>>:
>
>     On 06/06/2013 01:58 PM, Kai Krakow wrote:
>
>         George Mitchell <george@chinilu.com
>         <mailto:george@chinilu.com>> schrieb:
>
>             I am seeing a huge improvement in boot performance since
>             doing a system
>             wide file by file defragementation of metadata.  In fact
>             in the four
>             sequential boots since completing this process, I have not
>             seen one
>             open_ctree failure so far.  This leads me to suspect that
>             the open_ctree
>             boot failures that have been plaguing me since install
>             have been related
>             to metadata fragmentation.  So I would advise anyone else
>             experiencing
>             open_ctree boot problems to defragment their metatdata and
>             see if that
>             helps.  It certainly seems to have helped me in that regard.
>
>         I suspect this observation comes from btrfs being able to
>         faster initialize
>         itself during kernel detection since you defragmented it. Try
>         to add
>         root_delay=2 to your kernel command line and see if it
>         improves on this
>         particular problem.
>
>         I had this myself and root_delay=1 fixed it for me. Before, in
>         about 90% of
>         all boots it came up with the ctree error. After, it never
>         happened again.
>
>         Regards,
>         Kai
>
>         --
>         To unsubscribe from this list: send the line "unsubscribe
>         linux-btrfs" in
>         the body of a message to majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>
>         More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>
>     Thanks,  I tried that route and it, unfortunately, did not do
>     anything for me.  But the defragmentation continues to do the job
>     every time.  I am now going to make everything on the OS side
>     "nodatacow" and am expecting that will further relieve the
>     problem. The problem NEVER occurs in a normal environment, only in
>     the initrd environment.  There is something uniquely different
>     about the initrd environment that triggers this problem.
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-btrfs" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:40544 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3AVS7R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 13:59:17 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122185916.HRBO2891.eastrmfepo101.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 13:59:16 -0500
Message-ID: <50FEE183.5000706@czarc.net>
Date: Tue, 22 Jan 2013 13:59:15 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH 13/13] trivial patch for btrfs-progs
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <1358715858-4469-14-git-send-email-gene@czarc.net> <20130121174054.GA7971@twin.jikos.cz>
In-Reply-To: <20130121174054.GA7971@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2013 12:40 PM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:18PM -0500, Gene Czarcinski wrote:
>> From: Arvin Schnell <aschnell@suse.de>
>>
>> Hi,
>>
>> please find attached a trivial patch for btrfs-progs. Likely not
>> strictly needed but I noticed valgrind complaining about
>> uninitialised memory in the ioctl call.
>>
>> Regards,
>>    Arvin
>>
>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> I've updated the changelog to say
> ---
>      btrfs-progs: initialize data before send ioctl
>
>      Likely not strictly needed but I noticed valgrind complaining about
>      uninitialised memory in the ioctl call.
>
>      Signed-off-by: Arvin Schnell <aschnell@suse.de>
> ---
>
> is it ok for both of you?
>
> david
>
Of course.  It is usually a good thing to not make assumptions where you 
do not have to.

Gene

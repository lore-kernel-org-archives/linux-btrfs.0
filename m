Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33304 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3ISRDc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 13:03:32 -0400
Message-ID: <523B2E62.7030801@sandeen.net>
Date: Thu, 19 Sep 2013 12:03:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: unify apostrophes in output files
References: <1379536166-19232-1-git-send-email-jbacik@fusionio.com> <20130918211325.GB4330@dastard> <523B2455.4000609@redhat.com> <CAOi1vP_w25B7Lui3CYPXvbvSFdO1-xdjxJySHfi3x1164W1+Eg@mail.gmail.com>
In-Reply-To: <CAOi1vP_w25B7Lui3CYPXvbvSFdO1-xdjxJySHfi3x1164W1+Eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/19/13 11:54 AM, Ilya Dryomov wrote:

...

>> diff --git a/check b/check
>> index 4085eae..ba7fd21 100755
>> --- a/check
>> +++ b/check
>> @@ -478,6 +478,10 @@ do
>>                 echo " - no qualified output"
>>                 err=true
>>             else
>> +
>> +               # coreutils 2.16+ changed quote formats in error messages from
> 
> Should that be 8.16+?

probably so!

> Thanks,
> 
>                 Ilya
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


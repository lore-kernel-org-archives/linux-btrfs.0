Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab3CDWet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:34:49 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24MYmc4005235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:34:48 -0500
Message-ID: <51352187.80707@redhat.com>
Date: Mon, 04 Mar 2013 16:34:47 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/14] btrfs-progs: Error handling in scrub_progress_cycle()
 thread
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com> <1362436804-16766-15-git-send-email-sandeen@redhat.com> <20130304220034.GC1658@lenny.home.zabbo.net>
In-Reply-To: <20130304220034.GC1658@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/4/13 4:00 PM, Zach Brown wrote:
>> -	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
>> +	ret = -pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
>>  	if (ret)
>> -		return ERR_PTR(-ret);
>> +		goto out;
> 
> Am I the only one who finds ret = -pthread_*() pretty odd? :)  (ret = -0
> on success.. ok.. I guess..)
> 
> I'd have done something like
> 
> 	err = pthread_*()
> 	if (err) {
> 		ret = -err;
> 
> so that it looks like the -1/errno pattern that our brains already have
> to deal with.
> 
> - z
> 

Yeah, I wasn't thrilled either.  Fair enough.  I'll do that & resend.

-Eric

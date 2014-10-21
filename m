Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62027 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932576AbaJUTTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 15:19:30 -0400
Date: Tue, 21 Oct 2014 15:19:09 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs for stable (mostly 3.17)
To: Greg KH <gregkh@linuxfoundation.org>
CC: Filipe Manana <fdmanana@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, <stable@vger.kernel.org>
Message-ID: <1413919149.13632.0@mail.thefacebook.com>
In-Reply-To: <20141020221252.GA2101@kroah.com>
References: <20141020221252.GA2101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, Oct 20, 2014 at 6:12 PM, Greg KH <gregkh@linuxfoundation.org> 
wrote:
> On Mon, Oct 20, 2014 at 01:22:22PM +0100, Filipe Manana wrote:
> 
>>  May I suggest porting the following commit to 3.14 too?
>> 
>>  
>> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id%3D766b5e5ae78dd04a93a275690a49e23d7dcb1f39&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=4HB2GrskctbPsSOzamEf9hTilGJUhvqoPLn0LWCzaTI%3D%0A&s=c55d2716c1968c22c220de980059a704c31aa637a7036e25909da9cc960bd0f4
>> 
>>  It fixes a data corruption issue for an incremental send. 
>> Particularly
>>  important, IMHO, as the corruption happens silently (no errors 
>> returned
>>  to user space nor any sort of warnings/errors in syslog, etc). It
>>  affects only 3.14, and the change applies cleanly on 3.14.22.
> 
> Chris, any objection for me taking this?

On vacation, sorry for the lag.  Please do take this one too.  Thanks 
Filipe.

-chris




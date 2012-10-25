Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:44881 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2JYTWB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 15:22:01 -0400
Message-ID: <5089917E.7090804@inwind.it>
Date: Thu, 25 Oct 2012 21:22:38 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: [PATCH 5/5] Update the man page with the new prefixes.
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com> <1351014715-5727-6-git-send-email-kreijack@inwind.com> <20121025161355.GJ10679@twin.jikos.cz>
In-Reply-To: <20121025161355.GJ10679@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-25 18:13, David Sterba wrote:
> Hi,
> 
> one minor typo
> 
> On Tue, Oct 23, 2012 at 07:51:55PM +0200, Goffredo Baroncelli wrote:
>> --- a/man/btrfs.8.in
>> +++ b/man/btrfs.8.in
>> @@ -184,6 +184,9 @@ defragment operations.
>>  
>>  \fB-t size\fP defragment only files at least \fIsize\fR bytes big
>>  
>> +For \fBstart\fP, \fBlen\fP, \fBsize\fP it is possible to append a prefix
>                                                                      ^^^^^^
> suffix

Thanks, this week I will update the patches.

> 
>> +like \fBk\fP for 1 KBytes, \fBm\fP for 1 MBytes...
>> +
> 
> david
> .
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

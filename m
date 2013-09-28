Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3I1OeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 10:34:20 -0400
Message-ID: <5246E8D8.10205@oracle.com>
Date: Sat, 28 Sep 2013 22:34:00 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: device add should check existing FS before
 adding
References: <1380303005-10164-1-git-send-email-anand.jain@oracle.com> <20130927183246.GW30372@lenny.home.zabbo.net>
In-Reply-To: <20130927183246.GW30372@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2013 02:32 AM, Zach Brown wrote:
>> @@ -49,14 +50,17 @@ static int cmd_add_dev(int argc, char **argv)
>>   	int	i, fdmnt, ret=0, e;
>>   	DIR	*dirstream = NULL;
>>   	int discard = 1;
>> +	int force = 0;
>> +	char estr[100];
>>
>> +		res = test_dev_for_mkfs(argv[i], force, estr);
>> +		if (res) {
>> +			fprintf(stderr, "%s", estr);
>>   			continue;
>>   		}
>
> This test_dev_for_mkfs() error string interface is bad.  The caller
> should not have to magically guess the string size that the function is
> going to use.  Especially because users can trivial provide giant paths
> that exhaust that tiny buffer.  If an arbitrarily too small buffer in
> the caller was needed at all, its length should have been passed in with
> the string pointer.  (Or a string struct that all C projects eventually
> grow.)
>
> But all the callers just immediately print it anyway.  Get rid of that
> string argument entirely and just have test_dev_for_mkfs() print the
> strings.

  Right. But this patch didn't introduce test_dev_for_mkfs()
  revamp of it will be good in a separate patch as it touches
  other functions as well.

Thanks, Anand



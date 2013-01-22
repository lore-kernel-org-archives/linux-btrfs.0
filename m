Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:57970 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AVReE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:34:04 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122173402.JFZX23841.eastrmfepo103.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 12:34:02 -0500
Message-ID: <50FECD89.9050101@czarc.net>
Date: Tue, 22 Jan 2013 12:34:01 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, Nageswara R Sastry <nasastry@in.ibm.com>
Subject: Re: [PATCH 01/13] btrfs-progs: btrfs-image.c: Added NULL pointer
 check.
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <1358715858-4469-2-git-send-email-gene@czarc.net> <20130121155630.GI19967@twin.jikos.cz>
In-Reply-To: <20130121155630.GI19967@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2013 10:56 AM, David Sterba wrote:
> On Sun, Jan 20, 2013 at 04:04:06PM -0500, Gene Czarcinski wrote:
>> From: Nageswara R Sastry <nasastry@in.ibm.com>
>>
>> Check for the return value of 'open_ctree()' before dereferencing it.
>>
>> --- a/btrfs-image.c
>> +++ b/btrfs-image.c
>> @@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
>>   	int ret;
>>   
>>   	root = open_ctree(input, 0, 0);
>> +	BUG_ON(!root);
> Bug_on is not the right fix here, I prefer a more extensive fix
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15305
>
> which prints a message and exits.
>
>>   	BUG_ON(root->nodesize != root->leafsize);
>>   
>>   	ret = metadump_init(&metadump, root, out, num_threads,
I missed this better fix because I only started looking for outstanding 
patches starting in June/July 2012.

Besides, I suspect you are a lot more knowledgeable to make the judgment 
as to a "good" fix.

Gene

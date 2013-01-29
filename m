Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51100 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3A2Qxs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 11:53:48 -0500
Message-ID: <5107FE65.8090603@oracle.com>
Date: Wed, 30 Jan 2013 00:52:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Gene Czarcinski <gene@czarc.net>
Subject: Re: [PATCH 1/2] btrfs-progs: refactor check_label()
References: <51076B0C.2060602@oracle.com> <20130129151916.GL16977@twin.jikos.cz>
In-Reply-To: <20130129151916.GL16977@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/29/2013 11:19 PM, David Sterba wrote:
> On Tue, Jan 29, 2013 at 02:24:12PM +0800, Jeff Liu wrote:
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1122,17 +1122,21 @@ char *pretty_sizes(u64 size)
>>        -1    if the label is too long
>>        -2    if the label contains an invalid character
>>   */
>> -int check_label(char *input)
>> +static int check_label(char *input)
>>  {
>>         int i;
>>         int len = strlen(input);
>>  
>> -       if (len > BTRFS_LABEL_SIZE) {
>> +       if (len > BTRFS_LABEL_SIZE - 1) {
>> +		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
>> +			input, BTRFS_LABEL_SIZE - 1);
>>                 return -1;
>>         }
>>  
>>         for (i = 0; i < len; i++) {
>>                 if (input[i] == '/' || input[i] == '\\') {
>> +			fprintf(stderr, "ERROR: Label %s contains invalid "
>> +				"characters\n", input);
>>                         return -2;
>>                 }
> 
> Plase drop this check, see
> http://repo.or.cz/w/btrfs-progs-unstable/devel.git/commit/79e0e445fc2365e47fc7f060d5a4445d37e184b8
> (also function comment and maybe the callers)
> 
> "btrfs-progs: kill check for /'s in labels
> 
> This patch kills a check in mkfs's label stuff which doesn't allow
> labels that have /'s in them.  This causes problems for Anaconda which
> try to label volumes with their mountpoints."
> (mkfs.c)
Ok, so looks we can safely clean this routine out of the code base since
there is no other users call it if am not missing anything.

Thanks,
-Jeff


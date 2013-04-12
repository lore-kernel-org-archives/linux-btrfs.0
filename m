Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:9690 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3DLHo4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 03:44:56 -0400
Message-ID: <5167BB75.9080604@giantdisaster.de>
Date: Fri, 12 Apr 2013 09:44:53 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] Btrfs-progs: enhance 'btrfs subvolume list'
References: <cover.1365696891.git.sbehrens@giantdisaster.de> <8c3c7c8ec1747e9fe96ccf17ccc2b6669e1d1fb8.1365696891.git.sbehrens@giantdisaster.de> <51675C33.30704@cn.fujitsu.com>
In-Reply-To: <51675C33.30704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Apr 2013 08:58:27 +0800, Wang Shilong wrote:
>> "btrfs subvolume list" gets a new option "--fields=..." which allows
>> to specify which pieces of information about subvolumes shall be
>> printed. This is necessary because this commit also adds all the so
>> far missing items from the root_item like the received UUID, all
>> generation values and all time values.
>>
>> The parameters to the "--fields" option is a list of items to print:
>> --fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,
>>          stime,rtime,path,rootid,parent,topid,all
>>
> 
> 
> The new option '--fields' is helpful, however, i am wondering
> whether we should remove the old options '-g', '-c'...etc. These
> options has been there for a period of time,some shell script may use
> it.
> 
> IMO, to ensure compatibility, we'd better keep it.

What do other people on the list think about maintaining compatibility
in this case?

IMO it is acceptable to break compatibility for such a change. It would
confuse everybody who reads the man page that there are 1 1/2 ways to
configure the printed columns.


[...]
>>  static const char * const cmd_subvol_list_usage[] = {
>> -	"btrfs subvolume list [-agopurts] [-G [+|-]value] [-C [+|-]value] "
>> -	"[--sort=gen,ogen,rootid,path] <path>",
>> +	"btrfs subvolume list [-roast] [-G [+|-]value] [-C [+|-]value] "
>> +	"[--sort=gen,ogen,rootid,path] "
>> +	"[--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,"
>> +	"otime,stime,rtime,path,rootid,parent,topid,all] <path>",
>>  	"List subvolumes (and snapshots)",
>>  	"",
>> -	"-p           print parent ID",
>>  	"-a           print all the subvolumes in the filesystem and",
>>  	"             distinguish absolute and relative path with respect",
>>  	"             to the given <path>",
>> -	"-c           print the ogeneration of the subvolume",
>> -	"-g           print the generation of the subvolume",
>>  	"-o           print only subvolumes bellow specified path",
>> -	"-u           print the uuid of subvolumes (and snapshots)",
>> -	"-q           print the parent uuid of the snapshots",
>>  	"-t           print the result as a table",
>>  	"-s           list snapshots only in the filesystem",
>>  	"-r           list readonly subvolumes (including snapshots)",
>> @@ -308,6 +305,9 @@ static const char * const cmd_subvol_list_usage[] = {
>>  	"             list the subvolume in order of gen, ogen, rootid or path",
>>  	"             you also can add '+' or '-' in front of each items.",
>>  	"             (+:ascending, -:descending, ascending default)",
>> +	"--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,",
>> +	"         stime,rtime,path,rootid,parent,topid,all",
>> +	"             explicitly specify the fields to print",
>>  	NULL,
>>  };
[...]

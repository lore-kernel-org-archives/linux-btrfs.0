Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:19053 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3IEHKy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 03:10:54 -0400
Message-ID: <52282E7B.6010309@giantdisaster.de>
Date: Thu, 05 Sep 2013 09:10:51 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs-progs:free strdup()s that are not freed
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1378348738-14451-6-git-send-email-guihc.fnst@cn.fujitsu.com> <52282BF7.6040605@giantdisaster.de>
In-Reply-To: <52282BF7.6040605@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 05 Sep 2013 09:00:07 +0200, Stefan Behrens wrote:
> On Thu, 5 Sep 2013 10:38:58 +0800, Gui Hecheng wrote:
>> The strdup()s not freed are reported as memory leaks by valgrind.
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> ---
>>  cmds-subvolume.c | 48 ++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 34 insertions(+), 14 deletions(-)

Just noticed that you had already sent a V2 with the things fixed that I
have commented, but you sent the 5/5 as a 1/5 and added the changelog
v1->v2 "none" which made it difficult to recognize :). But maybe David
Sterba is smart enough when he picks up the patches.


>>
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index e1fa81a..51c529c 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
[...]

>> @@ -75,6 +75,8 @@ static int cmd_subvol_create(int argc, char **argv)
>>  {
>>  	int	retval, res, len;
>>  	int	fddst = -1;
>> +	char	*dupname = NULL;
>> +	char	*dupdir = NULL;
>>  	char	*newname;
>>  	char	*dstdir;
>>  	char	*dst;
>> @@ -119,10 +121,10 @@ static int cmd_subvol_create(int argc, char **argv)
>>  		goto out;
>>  	}
>>  
>> -	newname = strdup(dst);
>> -	newname = basename(newname);
>> -	dstdir = strdup(dst);
>> -	dstdir = dirname(dstdir);
>> +	dupname = strdup(dst);
>> +	newname = basename(dupname);
>> +	dupdir = strdup(dst);
>> +	dstdir = dirname(dupdir);
>>  
>>  	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
>>  	     strchr(newname, '/') ){
>> @@ -175,6 +177,11 @@ out:
>>  	close_file_or_dir(fddst, dirstream);
>>  	free(inherit);
>>  
>> +	if (dupname != NULL)
>> +		free(dupname);
>> +	if (dupdir != NULL)
>> +		free(dupdir);
>> +
> 
> free(3) already checks the pointer for NULL, no need to do it on your own.
> 
> 
>>  	return retval;
>>  }
>>  
>> @@ -208,6 +215,8 @@ static int cmd_subvol_delete(int argc, char **argv)
>>  	int	res, fd, len, e, cnt = 1, ret = 0;
>>  	struct btrfs_ioctl_vol_args	args;
>>  	char	*dname, *vname, *cpath;
>> +	char	*dupdname = NULL;
>> +	char	*dupvname = NULL;
>>  	char	*path;
>>  	DIR	*dirstream = NULL;
>>  
>> @@ -230,10 +239,10 @@ again:
>>  	}
>>  
>>  	cpath = realpath(path, NULL);
>> -	dname = strdup(cpath);
>> -	dname = dirname(dname);
>> -	vname = strdup(cpath);
>> -	vname = basename(vname);
>> +	dupdname = strdup(cpath);
>> +	dname = dirname(dupdname);
>> +	dupvname = strdup(cpath);
>> +	vname = basename(dupvname);
>>  	free(cpath);
>>  
>>  	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
>> @@ -274,6 +283,10 @@ again:
>>  	}
>>  
>>  out:
>> +	if (dupdname != NULL)
>> +		free(dupdname);
>> +	if (dupvname != NULL)
>> +		free(dupvname);
> 
> Here again.
> 
> 
>>  	cnt++;
>>  	if (cnt < argc)
>>  		goto again;
>> @@ -495,6 +508,8 @@ static int cmd_snapshot(int argc, char **argv)
>>  	int	res, retval;
>>  	int	fd = -1, fddst = -1;
>>  	int	len, readonly = 0;
>> +	char	*dupname = NULL;
>> +	char	*dupdir = NULL;
>>  	char	*newname;
>>  	char	*dstdir;
>>  	struct btrfs_ioctl_vol_args_v2	args;
>> @@ -562,14 +577,14 @@ static int cmd_snapshot(int argc, char **argv)
>>  	}
>>  
>>  	if (res > 0) {
>> -		newname = strdup(subvol);
>> -		newname = basename(newname);
>> +		dupname = strdup(subvol);
>> +		newname = basename(dupname);
>>  		dstdir = dst;
>>  	} else {
>> -		newname = strdup(dst);
>> -		newname = basename(newname);
>> -		dstdir = strdup(dst);
>> -		dstdir = dirname(dstdir);
>> +		dupname = strdup(dst);
>> +		newname = basename(dupname);
>> +		dupdir = strdup(dst);
>> +		dstdir = dirname(dupdir);
>>  	}
>>  
>>  	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
>> @@ -630,6 +645,11 @@ out:
>>  	close_file_or_dir(fd, dirstream2);
>>  	free(inherit);
>>  
>> +	if (dupname != NULL)
>> +		free(dupname);
>> +	if (dupdir != NULL)
>> +		free(dupdir);
>> +
> 
> And here.
> 
> 
>>  	return retval;
>>  }


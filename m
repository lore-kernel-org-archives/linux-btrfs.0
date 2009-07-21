From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Random write regression
Date: Tue, 21 Jul 2009 09:48:38 -0500
Message-ID: <4A65D546.9000602@austin.ibm.com>
References: <4A646D0E.1060006@austin.ibm.com> <3d0408630907210004g34a49196xb235aa2f6a1f0f1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630907210004g34a49196xb235aa2f6a1f0f1b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan Zheng wrote:
> 2009/7/20 Steven Pratt <slpratt@austin.ibm.com>:
>   
>> Finally got around to going through latest data.  Seems like we lost all the
>> random write performance gains.  Creates are better, but total regression on
>> the random workload.  Sequential reads seem to have dropped as well.
>>
>> Results are uploading now.
>>  http://btrfs.boxacle.net/repository/raid/history/History.html
>>
>> These are for RAID only as single disk system still having issues completing
>> btrfs runs.  Also, missing oprofile duw to oprofile causing an NMI and
>> killing the system.
>>
>> Chris, this was built on 7/6, but I see no new changes sine 7/2/.
>> Steve
>>
>>
>>     
>
> The output of ffsb in the latest 128 threads random odirect write benchmark was
> ....
> checking existing fs: /mnt/ffsb1
> fs setup took 6 secs
> Syncing()...2 sec
> ....
>
> The corresponding output on 30 June was
> ....
> creating new fileset /mnt/ffsb1
> fs setup took 847 secs
> Syncing()...1 sec
> ....
>
> It seems the filesystem used in the latest benchmark wasn't freshly created.
>   
Yes, the older (better) random write performance did indeed recreate the 
files before the test. Thanks for catching this.  I had 2 job files, 1 
for just btrfs and 1 for all file systems and the reuse flag is 
different between them.  Please ignore this regression.   I will re-run 
without the reuse flag and expect things to be similar.  This does 
indicate that btrfs degrades quite rapidly under random write, but that 
is a separate topic.

Steve

> Yan, Zheng
>   


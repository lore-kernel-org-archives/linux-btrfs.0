From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Hang running fs_mark
Date: Thu, 25 Sep 2008 16:11:54 -0400
Message-ID: <48DBF08A.6050000@redhat.com>
References: <20080925175643.GA14205@unused.rdu.redhat.com> <1222367822.7028.55.camel@think.oraclecorp.com> <20080925183435.GB14205@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080925183435.GB14205@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Thu, Sep 25, 2008 at 02:37:02PM -0400, Chris Mason wrote:
>   
>> On Thu, 2008-09-25 at 13:56 -0400, Josef Bacik wrote:
>>     
>>> Hello,
>>>
>>> Reporting this on behalf of ric.  He was running the following fs_mark command
>>>
>>> ./fs_mark -d /mnt/test -s 20480 -D 64 -t 8 -F
>>>
>>> Seems it hung and wasn't making any progress.  He managed to get some sysrq-t,
>>> which is at http://people.redhat.com/jwhiter/fs-mark-hang.txt towards the bottom
>>> of the document.  He could ctrl+c and unmount the fs so its not a hard hang.
>>> Looks like we've just locked up behind a page lock somewhere.  I have to run off
>>> to class so I can't look into it too deeply so throwing this out there hoping
>>> somebody else figures it out :).  Thanks,
>>>       
>> Which kernel was this?
>>
>>
>>     
>
> Its 2.6.25.14-108.fc9.x86_64 and its kernel-unstable since yesterday I think he
> said, its just shy whatever patches you've pushed into git recently, it has
> yan's backref work plus a few other fixes.  Thanks,
>
> Josef 
>   

I can fire off a new test with the latest from unstable if that is of 
interest,

ric


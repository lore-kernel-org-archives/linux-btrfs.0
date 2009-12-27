From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: btrfsctl exit with 1 when succeed
Date: Mon, 28 Dec 2009 08:39:31 +0900
Message-ID: <4B37F033.30700@jp.fujitsu.com>
References: <E88DD564E9DC5446A76B2B47C3BCCA150221B14DD3@pdsmsx503.ccr.corp.intel.com> <4B340502.10806@jp.fujitsu.com> <200912251025.57158.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, zhipeng.gong@intel.com,
	chris.mason@oracle.com
To: kreijack@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912251025.57158.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you, I don't think of a devices scan.

After all, I wonder why. Return codes must be
coherent so that we can know good from no-good
by them. In this spec, it's very hard to make
shell scripts with btrfsctl. If there isn't good
reason, we need to fix it, I think.

(2009/12/25 18:25), Goffredo Baroncelli wrote:
> On Friday 25 December 2009, TARUISI Hiroaki wrote:
>> I also want to know why this conversion is needed.
>> This might be a typo, I think.
>>
>> Could someone tell us why?
>> Can we fix this conversion? Or shouldn't we fix it
>> considering back-compatibility?
>>
> 
> It is even worse: the result code returned by btrfsctl is not coherent.
> btrfsctl returns always 1 except:
> - after a devices scan (in this case the result is _always_ 0)
> - if the ioctl returns a value greater than 0 
> 
> In other all cases (error in the command line, the device btrfs-control 
> doesn't exists, error in opening a file) the return code is 1.
> 
> That doesn't permit to differentiate an error from a good return. 
> 
> BR
> Goffredo
> 
> 
>> Regards,
>> taruisi
>>
>> (2009/11/11 15:16), Gong, Zhipeng wrote:
>>> We'd like to use btrfsctl in a shell script, however, btrfsctl exit with 1 
> even if the operation is successful, which is opposite to the usual shell 
> command convention.
>>> Why btrfsctl add this conversion in the end?
>>>          if (ret)
>>>                   exit(0);
>>>          else
>>>                   exit(1);
>>>
>>> Thanks
>>> Zhipeng
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


-- 
taruisi


From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Error handling: How to "lose" a transaction
Date: Fri, 23 Dec 2011 13:43:05 +0800
Message-ID: <4EF414E9.3060009@cn.fujitsu.com>
References: <4EE7C7F2.2080905@suse.com> <20111214001319.GX31158@shiny> <4EF29D0C.90709@suse.de> <4EF2A24D.7040501@cn.fujitsu.com> <4EF2A641.7070308@suse.de> <4EF40DBF.4070505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EF40DBF.4070505@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/23/2011 01:12 PM, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/21/2011 10:38 PM, Jeff Mahoney wrote:
>> On 12/21/2011 10:21 PM, Liu Bo wrote:
>>> On 12/22/2011 10:59 AM, Jeff Mahoney wrote: Sorry I haven't 
>>> responded to this yet. I started digging right in and I've
>>> started to have some good results. It turns out there's already a
>>>  btrfs_cleanup_transaction call that will tear down outstanding 
>>> transactions. It's not perfect and I've fixed a few bugs in
>>> there, but it saved me a bunch of effort. I just wished I noticed
>>> it a day before since I had it half implemented myself. :)
>>
>>>> Hi Jeff,
>>>> Yes, it should be, and I wrote this cleanup_transaction where
>>>> I should notice you earlier... Anyway, thanks for your effort.
>>>> The error handling part has lots of corner cases, so I just
>>>> pick up a brute way to tear down the current transaction in
>>>> order to make the FS RO.
>> Oh, and it's worked great. The brute force method is a good start
>> and will address the most severe problems (and most cases) well.
>> I've decided to ignore most cases of -ENOMEM for now. The biggest
>> bug I ran into so far was calling mutex_lock while holding a
>> spinlock. It was a quick fix.
>>
>> The method I've generally used is to mark the transaction aborted
>> and pass the error up as quickly as possible, cleaning up the
>> local allocations and locks as I go. The transaction gets
>> completed normally, returns an error, isn't committed, and then is
>> destroyed (with others, potentially) when called from in 
>> btrfs_commit_transaction. Btrfs makes this super easy since we can 
>> just skip all the CoW writes.
> 
> 
> Now, just out of curiosity, would it be ok if I printed this when we
> ran out memory in deep call paths?
> 

I'm ok with this, but it depends on Chris :)

Indeed, ENOMEM in deep call paths is a big big trouble for us, we don't yet have
a graceful solution, and we can make an memory allocation with mask __GFP_NOFAIL
flags for simplicity, although it is not recommended:

 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures.  This modifier is deprecated and no new
 * users should be added.


>      FAIL WHALE!
> 
> W     W      W
> W        W  W     W
>               '.  W
>   .-""-._     \ \.--|
>  /       "-..__) .-'
> |     _         /
> \'-.__,   .__.,'
>  `'----'._\--'
> VVVVVVVVVVVVVVVVVVVVV
> 
> 
> Happy Holidays ;)
> 

Happy Holidays!

thanks,
liubo

> - -Jeff
> 
>> Thanks!
>>
>> -Jeff
>>
>>
>>>> thanks, liubo
>>> This afternoon I started running xfstests on a dm-linear mapped 
>>> partition. Halfway through a sufficiently long test, I swap out 
>>> the linear mapping to an error mapping. It still crashes, but 
>>> somewhat less spectacularly. There are still a ton of BUG_ON's I 
>>> need to eliminate as well as work out the usual I/O
>>> error-recovery issue of uninterruptible, unrecoverable writeback
>>> contexts and still-locked pages holding up exit. I'm pretty
>>> pleased with the results so far and am pretty optimistic.
>>> -Jeff
>>
>>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>>> linux-btrfs" in the body of a message to 
>>>> majordomo@vger.kernel.org More majordomo info at 
>>>> http://vger.kernel.org/majordomo-info.html
>>>>
>>
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJO9A2/AAoJEB57S2MheeWyiNIP/3Z6NETIXskkp+OVKTiF/gaP
> bopj2dp92BlURFHEj5vJoESm4cUtQKTx9J/DB3yc7JDzc0UcRs9KCqGV9UpH6y9/
> Zetzy3ZMsYyxvV5CZ50NGr+C1r5ULVGQ/UrPex/GT0bApcdBRMkFASLH8xkFl6dE
> dfRjir038GzjVX/Phy0VPm0mg8eg77aco11Xk2+Y1MdEhsEqI+cUQYgA8O9M7HWy
> 67Vv3KWxKC7PU6SYCPa0wGmQwTgs10GuKT9w+s7Ampy8iQhCgEuDo4dQxpRehQfp
> YwD/vlHwVATTAR2zMbRtI0BWa+ideBzcdQg1QrZxB3o026Z7ooy+/fTqS6MiUrXy
> mxGvb0g/BglK6Q86YQE77doIfJeUDLGoGQx2Zv1S9OzVwigo1a0LcP82P7yNnJBY
> oihql+FAYBXwjqiAQ+wUvo7wy0H+ltmQgWfUDf5wjDHquTRT1H0kE15Okc8MX8+T
> rmhp6vD1deX5Jz+JBIpCm94JhxUBPkBH2WksyA1jdLUOngHxRI0jmqz/5mPexV8e
> dChaq1rsjYs5Zbbv/jpaefnEw0kbZ0cqS7uDLVVoyjEqGnBpqjdwE86WYjxc4biM
> MkeSJ67Oof3ZGLWR0VQ+h4YnRjqAsMWsEd3jBLMo2krsr8ucc/UOzVDBVojDlGWJ
> Z2HunZuWJkNgcsBatVoS
> =z1sd
> -----END PGP SIGNATURE-----
> 


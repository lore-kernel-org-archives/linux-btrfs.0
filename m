From: Josef Bacik <josef@redhat.com>
Subject: Re: [btrfs-transacti] & btrfs-endio-wri] - WAS: Re: [btrfs-delalloc-]
Date: Fri, 01 Jul 2011 10:07:39 -0400
Message-ID: <4E0DD4AB.9040900@redhat.com>
References: <4E0D7323.9010202@corp.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Proskurin Kirill <k.proskurin@corp.mail.ru>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0D7323.9010202@corp.mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2011 03:11 AM, Proskurin Kirill wrote:
> On 06/30/2011 09:13 PM, Josef Bacik wrote:
>> On 06/30/2011 10:12 AM, Proskurin Kirill wrote:
>>> On 06/29/2011 08:14 PM, Josef Bacik wrote:
>>>>> Ok - I upgrade to 2.6.39-2 but it is seems to all things get worse.
>>>>> Now I see [btrfs-transacti]&   btrfs-endio-wri] 80-100% all the
> time and
>>>>> io performance looks like lower then before.
>>>>>
>>>>> Our scribe daemon in state D most of the time with half of a normal
>>>>> load. Only kernel was changed.
>>>>>
>>>>> Any performance tune recommendation?
>>>>>
>>>>
>>>> Can you get sysrq+w while this problem is happening so we can see whats
>>>> going on?  Thanks,
>>>
>>> I attached sysrq+w. Hope it helps.
>>>
>>
>> Heh so it just looks like you are writing a bunch of stuff, that's not
>> particularly helpful.  What does this program do generically?  How full
>> is your fs?  Do you have snapshots/subvolumes?  If so how many?  Thanks,
> 
> I found what my btrfs partition now is really slow. Something wrong
> happend. I try on 2.6.32 and 2.6.39 - same result. It is because
> partition is almost full?
> 
> I run a simple cycle to clean some old files:
> for i in `cat /tmp/delit`; do rm -f $i ; done
> 
> And it is takes about 5-10 second per file to delete.
> I get sysrq+w while rm is work - it is attached.
> 

Just a shot in the dark, but will you give this a shot and let me know
how it goes?  Thanks

Josef

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 654755b..698a406 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -475,12 +475,6 @@ static int __btrfs_end_transaction(struct
btrfs_trans_handle *trans,
 		    trans->transaction->delayed_refs.num_heads_ready > 64) {
 			trans->delayed_ref_updates = 0;

-			/*
-			 * do a full flush if the transaction is trying
-			 * to close
-			 */
-			if (trans->transaction->delayed_refs.flushing)
-				cur = 0;
 			btrfs_run_delayed_refs(trans, root, cur);
 		} else {
 			break;

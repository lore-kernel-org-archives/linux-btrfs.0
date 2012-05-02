From: Daniel J Blueman <daniel@quora.org>
Subject: Re: fs going r/o when out of space...
Date: Wed, 2 May 2012 22:27:54 +0800
Message-ID: <CAMVG2suiz5OeWuiz9om_cv=7+yBq2Je7izh-Lv-rKkUae=zMig@mail.gmail.com>
References: <CAMVG2svvV4DDkytGBusSm_M0-H+Qnoo9R=wuWOtg-5qL2uXTag@mail.gmail.com>
	<4FA13E36.4000401@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA13E36.4000401@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2 May 2012 22:01, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/02/2012 01:44 AM, Daniel J Blueman wrote:
>> I see the filesystem going readonly when run_clustered_refs
>> returns -ENOSPC [1], so it looks like we need something like:
>>
>> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@
>> -2451,7 +2451,8 @@ again: ret = run_clustered_refs(trans, root,
>> &cluster); if (ret < 0) { spin_unlock(&delayed_refs->lock); -
>> btrfs_abort_transaction(trans, root, ret); +
>> if (ret != -ENOSPC) +
>> btrfs_abort_transaction(trans, root, ret); return ret; }
>>
>> No?
>
> No. In most cases ENOSPC is indistinguishable from any other error. An
> ENOSPC in deep code means that the reservation for the transaction
> wasn't big enough.

Ahh, makes sense. When I get some time, I'll dump the transaction
state and check how the reservation code calculates the length...

Thanks,
  Daniel
-- 
Daniel J Blueman

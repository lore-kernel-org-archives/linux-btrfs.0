Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43216 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbaI3PzF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 11:55:05 -0400
Message-ID: <542AD236.2000609@fb.com>
Date: Tue, 30 Sep 2014 11:54:30 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
References: <1411704901-12723-1-git-send-email-eguan@redhat.com> <1411704901-12723-2-git-send-email-eguan@redhat.com> <5429AD14.5000805@fb.com> <20140930154809.GQ13912@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20140930154809.GQ13912@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2014 11:48 AM, Eryu Guan wrote:
> On Mon, Sep 29, 2014 at 03:03:48PM -0400, Josef Bacik wrote:
>> On 09/26/2014 12:14 AM, Eryu Guan wrote:
>>> Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
>>> with fsstress running in background.
>>>
>>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>>> ---
> [snip]
>>> +	args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
>>> +	echo "Run fsstress $args" >>$seqres.full
>>> +	$FSSTRESS_PROG $args >/dev/null 2>&1 &
>>> +	fsstress_pid=$!
>>> +
>>> +	echo -n "Start balance worker: " >>$seqres.full
>>> +	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
>>> +	balance_pid=$!
>>> +	echo "$balance_pid" >>$seqres.full
>>> +
>>> +	echo -n "Start subvolume worker: " >>$seqres.full
>>> +	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
>>> +	subvol_pid=$!
>>> +	echo "$subvol_pid" >>$seqres.full
>>> +
>>> +	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
>>> +	wait $fsstress_pid
>>> +
>>> +	kill $balance_pid $subvol_pid
>>> +	wait
>>> +	# wait for the balance operation to finish
>>> +	while ps aux | grep "balance start" | grep -qv grep; do
>>> +		sleep 1
>>> +	done
>>
>> This bit isn't needed, killing the balance pid also won't do anything, just
>> waiting is enough, it'll only exit once the balance is finished. If you
>> really want to stop the balance you can use
>
> I think it's still needed, or the balance process would block the
> later umount and test fails like
>
> --- tests/btrfs/059.out 2014-09-26 11:35:43.932850826 +0800
> +++ /root/xfstests/results//btrfs/059.out.bad   2014-09-30 23:29:47.538310375 +0800
> @@ -1,2 +1,9 @@
>   QA output created by 059
>   Silence is golden
> +umount: /mnt/testarea/scratch: target is busy.
> +        (In some cases useful info about processes that use
> +         the device is found by lsof(8) or fuser(1))
> +umount: /mnt/testarea/scratch: target is busy.
> +        (In some cases useful info about processes that use
> +         the device is found by lsof(8) or fuser(1))
> +_check_btrfs_filesystem: filesystem on /dev/mapper/rhel_hp--dl388eg8--01-testlv2 is inconsistent (see /root/xfstests/results//btrfs/059.full)
>
> Adding debug output of "lsof $SCRATCH_MNT" and "ps aux | grep btrfs"
> before umount shows it's the balance process is still running and
> blocks the umount.
>
> lsof /mnt/testarea/scratch
> btrfs   13491 root    3r   DIR   0,40       42  256 /mnt/testarea/scratch
> ps aux | grep btrfs
> ....
> root     13491  7.0  0.0  18660  1312 pts/1    D+   23:29   0:00 /usr/sbin/btrfs balance start /mnt/testarea/scratch
>
> Killing the balance pid is to stop any further balance operation, wait
> is waiting for the child process (_btrfs_stress_balance), not the
> child's child process (balance process). So only wait is not enough,
> we should wait for the balance to finish explicitly.
>
> This is also true for the rest of the test cases in this series. This
> is kind of ugly, but I cannot figure out a better solution right now..
>

Oh duh sorry, I missed that it was a loop of btrfs balance start, not 
just btrfs balance start &.  Ok in that case instead use

btrfs balance status

and loop on that until it is done and then exit, that way it is clear 
what we are waiting on, but really I'm not married to the idea either so 
if it ends up being too much trouble just skip it.  You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Whenever you re-roll with your whitespace changes and whatever other 
cleanups you add.  Thanks,

Josef


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-2.smtp-out.eu-west-1.amazonses.com ([54.240.4.2]:57928 "EHLO
        a4-2.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727616AbeIIBcv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Sep 2018 21:32:51 -0400
Subject: Re: Transactional btrfs
Cc: linux-btrfs@vger.kernel.org
References: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
 <228f7179-6c5c-4412-2bb1-b0e73439b05a@gmail.com>
 <20180908162453.ewlksc5wf7w73ak2@angband.pl>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <01020165baeef6ff-eca39c84-99b6-4a19-8e94-f5449540fed3-000000@eu-west-1.amazonses.com>
Date: Sat, 8 Sep 2018 20:45:47 +0000
MIME-Version: 1.0
In-Reply-To: <20180908162453.ewlksc5wf7w73ak2@angband.pl>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 08.09.2018 um 18:24 schrieb Adam Borowski:
> On Thu, Sep 06, 2018 at 06:08:33AM -0400, Austin S. Hemmelgarn wrote:
>> On 2018-09-06 03:23, Nathan Dehnel wrote:
>>> So I guess my question is, does btrfs support atomic writes across
>>> multiple files? Or is anyone interested in such a feature?
>>>
>> I'm fairly certain that it does not currently, but in theory it would not be
>> hard to add.
>>
>> Realistically, the only cases I can think of where cross-file atomic
>> _writes_ would be of any benefit are database systems.
>>
>> However, if this were extended to include rename, unlink, touch, and a
>> handful of other VFS operations, then I can easily think of a few dozen use
>> cases.  Package managers in particular would likely be very interested in
>> being able to atomically rename a group of files as a single transaction, as
>> it would make their job _much_ easier.
> I wonder, what about:
> sync; mount -o remount,commit=9999999,flushoncommit
> eatmydata apt dist-upgrade
> sync; mount -o remount,commit=30,noflushoncommit
>
> Obviously, this gets fooled by fsyncs, and makes the transaction affects the
> whole system (if you have unrelated writes they won't get committed until
> the end of transaction).  Then there are nocow files, but you already made
> the decision to disable most features of btrfs for them.
>
> So unless something forces a commit, this should already work, giving
> cross-file atomic writes, renames and so on.

Now combine this with snapshot root, then on success rename exchange to
root and you are there.

Btrfs had in the past TRANS_START and TRANS_END ioctls (for ceph, I
think), but no rollback (and therefore no error handling incl. ENOSPC).

If you want to look at a working file system transaction mechanism, you
should look at transactional NTFS (TxF). They are writing they are
deprecating it, so it's perhaps not very widely used. Windows uses it
for updates, I think.

Specifically for btrfs, the problem would be that it really needs to
support multiple simultaneous writers, otherwise one transaction can
block the whole system.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:39726 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbdLLQHi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 11:07:38 -0500
Received: by mail-qt0-f178.google.com with SMTP id k19so48484812qtj.6
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 08:07:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b8d8cfe-de39-b587-075a-65a502bf5e08@gmx.com>
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com> <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com> <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com> <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
 <d6722177-45c5-5010-ae48-ab8ec2a89141@gmx.com> <80e80ca8-5fbe-d0c9-c389-28df820f01dd@gmx.com>
 <CABi++uJD=XRVq-tUNZMep+GKFUKf8=okxrhhRGRo00aS=B9OOw@mail.gmail.com> <4b8d8cfe-de39-b587-075a-65a502bf5e08@gmx.com>
From: Benjamin Beichler <hadrian2002@googlemail.com>
Date: Tue, 12 Dec 2017 17:07:15 +0100
Message-ID: <CABi++uLpbCjO=-FMj7XVjBcbKspHnr37FY1KJvC52DXgnW2bPg@mail.gmail.com>
Subject: Re: Chunk-Recovery fails with alignment error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the patch unfortunately did not work, because I didn't know for which
version/tree was made, since it does not apply for 4.14. or 4.15. But
since I got your hint with the possibility of the old age of my btrfs
volume, I simply tried an old ubuntu live disk, and it mounted the
volume :-) Then I started a balance of the metadata, and hope it
reloacted the unfavorable placed block and voila - it is also
mountable in newer kernels. Then I updated my arch kernel in chroot
and now my system is running again.

I know changed to DUP metadata profile and currently I run a scrub,
but I hope there are no more serious errors.

I don't know whether the patch for checking bytenr < sectorsize should
be seen as regression bug, or the block was simply placed wrong by the
bcache bug.

All in all: Many thanks for the help !

kind regards

Benjamin

2017-12-11 0:50 GMT+01:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
>
>
> On 2017年12月11日 05:16, Benjamin Beichler wrote:
>> The patch let the chunk-recover be successful. But I'm no lucky man,
>> the recovered chunk tree does not work or other metadata is also
>> broken.
>>
>> Mounting the system is not successful (dmesg):
>> BTRFS critical (device dm-0): corrupt node, invalid item slot:
>> block=16384, root=1, slot=0
>> BTRFS error (device dm-0): failed to read chunk root
>> BTRFS error (device dm-0): open_ctree failed
>
> For this error, you could apply this diff to by-pass it:
>
> ------
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index ce4ed6ec8f39..355220e21c2e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -413,12 +413,6 @@ int btrfs_check_node(struct btrfs_root *root,
> struct extent_buffer *node)
>                 btrfs_node_key_to_cpu(node, &key, slot);
>                 btrfs_node_key_to_cpu(node, &next_key, slot + 1);
>
> -               if (!bytenr) {
> -                       generic_err(root, node, slot,
> -                               "invalid NULL node pointer");
> -                       ret = -EUCLEAN;
> -                       goto out;
> -               }
>                 if (!IS_ALIGNED(bytenr, root->fs_info->sectorsize)) {
>                         generic_err(root, node, slot,
>                         "unaligned pointer, have %llu should be aligned
> to %u",
> ------
>
> Thanks,
> Qu
>
>>
>> Therefore I tried a btrfs check --repair, this time without error:
>> https://gist.github.com/anonymous/5cf7ad9e187032d2c94db4f91bb62c24
>>
>> Then I tried btrfs check --init-extent-tree and this produces much
>> output. I put the beginning into here:
>> https://gist.github.com/anonymous/70e2482646a8235ee2327105d920dadd
>> From a fast view, the messages keep to be similar to the last of the
>> gist, but the messages in the beginning are not repeating. If it helps
>> I have complete compressed log.
>>
>> Then I tried a btrfs recover to get files, but for many files (also
>> improtant data, but I filtered the output) I get outputs like in:
>> https://gist.github.com/anonymous/1cc7f7ab5af33e76d0bf80960bb300eb
>>
>> Any new suggestions?
>>
>

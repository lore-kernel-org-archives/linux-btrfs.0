From: Zhang Jingwang <yyalone@gmail.com>
Subject: Re: a question about btrfs_writepage
Date: Fri, 11 Dec 2009 23:57:53 +0800
Message-ID: <4486336c0912110757p4deb48a8v4360cb33ae4a212b@mail.gmail.com>
References: <713d0d430912110356t3ed75c22u3b73fe2a19ed162a@mail.gmail.com>
	 <713d0d430912110400w3ace4ecbsc764d17a4485d96b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Hu Ruihuan <specter118@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <713d0d430912110400w3ace4ecbsc764d17a4485d96b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Good efficiency or good stableness, it's a question.

Every cow file system a block update will cause update to the block
point to it and recursively to root. Thus these file systems will
write more blocks than in-place update file systems(like ext3). This
cannot be avoided.

But do have some technologies to improve this. NetApp's WAFL uses
NVRAM-cache to log write operations. Log-structured file systems
always sequentially write to disk to achieve high throughput. BtrFS
uses a B+ tree to limit the height of the tree (so can reduce blocks
need to write in a COW operation), and uses a log tree to speed up
frequently sync operations (I'm not familiar with that).

2009/12/11 Hu Ruihuan <specter118@gmail.com>:
> 2009/12/11 Hu Ruihuan <specter118@gmail.com>:
>> Hi all,
>> =A0I am puzzled about a question, everytime when btrfs_writepage is
>> called, whethe the noeds in every levels of the fs tree will be
>> updated. This is the case as I read in the code, but if this case,
>> whether it will give rise to the low efficiency?
>> =A0 Thanks!
>>
> refer to the update of nodes, I mean a cow operation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Zhang Jingwang
National Research Centre for High Performance Computers
Institute of Computing Technology, Chinese Academy of Sciences
No. 6, South Kexueyuan Road, Haidian District
Beijing, China
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

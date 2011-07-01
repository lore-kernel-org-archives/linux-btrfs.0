From: Qiang Zhu <qiang.zhu@yahoo.cn>
Subject: =?utf-8?B?ZXh0ZW50cyBjaGFuZ2VkIHdoZW4gYWZ0ZXIg4oCcYnRyZnNfdHJ1bmNhdGU=?=
 =?utf-8?B?4oCd?=
Date: Fri, 1 Jul 2011 22:51:45 +0800 (CST)
Message-ID: <1309531905.7289.YahooMailNeo@web92416.mail.cnh.yahoo.com>
Reply-To: Qiang Zhu <qiang.zhu@yahoo.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi
=C2=A0when I write a file (file size:13K) to a disk covered by btrfs,th=
ere is only ONE extent to maitain the file in Btrfs.
After I use "btrfs_truncate" to truncate the file to 13K ,the number of=
 extents change to be TWO,and the content of the end 1K is overed by Ze=
ro=E3=80=82
=C2=A0 Is there someting worked to change the extents in "btrfs_truncat=
e"?
=C2=A0 Is taht a bug or you designed to do that changes ?
=C2=A0 wish your reply....
=C2=A0 thanks=C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

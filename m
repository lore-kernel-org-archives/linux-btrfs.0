Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:38884 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932116AbeCJO5K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 09:57:10 -0500
From: "Saravanan Shanmugham (sarvi)" <sarvi@cisco.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Change of Ownership of the filesystem content when cloning a
 volume
Date: Sat, 10 Mar 2018 14:57:08 +0000
Message-ID: <1686AD70-D64C-4861-824E-6F23DE51718D@cisco.com>
References: <DD5148B6-42C8-4598-A1E5-D652C6CF10E1@cisco.com>
 <5c0915bb-96bf-00a5-53d9-c511de8ed4b3@gmail.com>
In-Reply-To: <5c0915bb-96bf-00a5-53d9-c511de8ed4b3@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am 100% sure Netapp Flexclone can change the ownership of the clone content.
We are using that functionality right now.

https://docs.netapp.com/ontap-9/index.jsp?topic=%2Fcom.netapp.doc.dot-cm-cmpr-900%2Fvolume__clone__create.html

When you create clone in Flrxclone, you can specify a uid/gid. 
When the clone is created, all the files/directories/content in that clone is instantly owned by the uid/gid.

What I have been looking for is a similar functionality in Btrfs or ZFS?

I would like to put a diskimage on NFS, and mount it as a disk on my machine. 
And I want such snapshot and cloning(change ownership) capabilities in that disk image.

So I was considering BTRFS or ZFS, and was wondering if they miht have that feature.

Thanks
Sarvi
-----
Occam's Razor Rules

ï»¿On 3/9/18, 9:48 PM, "Andrei Borzenkov" <arvidjaar@gmail.com> wrote:

    10.03.2018 02:13, Saravanan Shanmugham (sarvi) Ğ¿Ğ¸ÑˆĞµÑ‚:
    > 
    > Netappâ€™s storage system, has the concept of snapshot/clones.
    > And when I create a clone from a snapshot, I can give/change ownership of entire tree in the volume to a different userid.
    
    You are probably mistaken. NetApp FlexClone (which you probably mean)
    does not have any ways to change volume content. Of course you can now
    mount this clone and do whatever you like from host, but that is
    completely unrelated to NetApp itself and can just as well be done using
    btrfs subvolume.
    
    > 
    > Is something like that possible in BTRFS?
    > 
    > We are looking to use CopyOnWrite to snapshot nightly build workspace and clone as developer workspaces to avoid building from scratch for developers,
    > And move directly for incremental builds.
    > For this we would like the clone workspace/volume to be instantly owned by the developer cloning the workspace.
    > 
    > Thanks,
    > Sarvi
    > -----
    > Occam's Razor Rules
    > 
    > 
    > Nï¿½ï¿½ï¿½ï¿½ï¿½rï¿½ï¿½yï¿½ï¿½ï¿½bï¿½Xï¿½ï¿½Ç§vï¿½^ï¿½)Şº{.nï¿½+ï¿½ï¿½ï¿½ï¿½{ï¿½nï¿½ß²)ï¿½ï¿½ï¿½w*?jgï¿½ï¿½ï¿½?ï¿½ï¿½ï¿½ï¿½ï¿½İ¢j/ï¿½ï¿½ï¿½zï¿½Ş–ï¿½ï¿½2ï¿½Ş™ï¿½ï¿½ï¿½&ï¿½)ß¡ï¿½aï¿½ï¿½ï¿½ï¿½?ï¿½Gï¿½ï¿½ï¿½hï¿½?ï¿½j:+vï¿½ï¿½ï¿½wï¿½Ù¥
    > 
    
    

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm

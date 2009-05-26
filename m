From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 0/6] Mixed back reference #2
Date: Tue, 26 May 2009 20:53:55 +0800
Message-ID: <4A1BE663.3040106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Here's the 2nd version of mixed back reference patches.
Changes since previous version:

- Add backward compatibility.
- Pack back ref items in extent item.
- Don't increase data extents' reference counts when tree log
  references them. 
- Remove the BTRFS_BLOCK_NO_OWNER_REF tree block flag, since
  it's too difficult to keep the flag consistent. (The purperse
  of this flag was helping btrfsck checking the correctness of
  the back reference system)

Thanks
Yan, Zheng 




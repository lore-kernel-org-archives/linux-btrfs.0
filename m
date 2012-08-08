Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964926Ab2HHNio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 09:38:44 -0400
Date: Wed, 8 Aug 2012 15:38:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Seto Hidetoshi <seto.hidetoshi@jp.fujitsu.com>,
        David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3 2/2] Btrfs: fix the snapshot that should not exist
Message-ID: <20120808133841.GC5873@ds.suse.cz>
Reply-To: dsterba@suse.cz
References: <501A04CE.9090408@cn.fujitsu.com>
 <20120802114631.GM17430@twin.jikos.cz>
 <501B2F20.7080903@cn.fujitsu.com>
 <20120803210301.GK2263@localhost.localdomain>
 <501CB8D8.2010405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <501CB8D8.2010405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 04, 2012 at 01:53:28PM +0800, Miao Xie wrote:
> But I'm not sure these two bugs is the same, so I need the test tool
> of David to look into it.

Attached. It's a set of scripts and has a few assumptions hardcoded,
like where the tar srouce is and the name of extracted directory, so
it'll need a few tweaks. Also the actions are started inside a tmux
session for convenience.

The expected stress load is to generate lots of files and directories,
snapshot create and delete and rm of the untarred directory. The 'rm'
step is delayed a few minutes so the tar generates enough data. On some
hosts the rm phase is fast and will clean the untar directory too
quickly.


david

--YiEDa0DAkWCtVeE4
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="test-subvol.tgz"
Content-Transfer-Encoding: base64

H4sIAApoIlAAA+1YW2/TMBTu6/wrDl0FG+A1di6VVvVhAh4BicsTm1iaOMRaLlXsrgUKv53j
pCMttw6pKwz8SVVq5djnxMffZx9roTRV0/FlmfU7NwQHMfB9fHLX56xuM8+rn0t0GHeY4wWu
7/GOw/jA8Tvg31RAq5gqHVYAnVhpUY3DX9iJSu0ioN1Cr+R/RhNJ42TrPjbln/Ggw9hg4Lju
gAcm/54zCDrgbD2SH+A/z//+nf5YFn2VEjXyySyVmYDjYVySPRGlJYxGIziPQy3Oyd5YV4mC
BC3Ue5ysHOIEeh/ZMT36RPZUJsQEeorEZSHIn/4qi+tilf+aU1WEE1qFRVzm2/Oxkf8+b/Sf
M+b4AfLfd1EGLP93gFX+MxLh70oDwIhAw/lmfYBZHFeMrxu9FyfPHj9/unzQXkT2olHv4CB6
wA4PrSbcBqzx3234H4tsqxqwkf8Dv93/ueF/wHy7/+8E6/v/G6AxdHusC2dw9y5ETWNdEswS
QZJnytiaxv2FSqfJIhVhDJQdfiMauJiEFqgCaGkl4a/DKv8NE3Qutu5jA/8Zd722/mPMnP9d
x/J/J2j5T/YhL6eFnpSy0A8hx4mBsVjSmBCZwJtGGkZw7x6cDUGnoliWCXVHqHvCJBOhEvhi
LjVJJCH56KpKSEUlUDpiWRVhLuC8QsnIZHEBFCsJ5/yQ1IKTd40OJfjP2GNViqkJtZGkxQI+
Qu0wCoui1FiMFDHk70FFlZxoNQTjdAifCNH5dA6FmFEllJJlYcSKKjDLfflFXy1mOEg5A6pX
3h47QC9gLYCmg5pkUv+0ywSCAOjlVeia0XeioFg/hXCKH3ba7V5nlBS6jU4yZ7iMYf1ofv3B
jlgdznI4/+tw3+30vzEkr4es0zALpQYPclkMofHBPYy5LSOhyoFWmN28L9DGVJJDI/3dZYZC
rcMobZO06spuDzvA2vmvXa5b9bHx/OfyVv+5a/Q/cB2r/7tAq/8/OfsNPsAclbOEz/3HJ69O
3r58/vrFoycv+zN5ISciliHFJZPqPDvCeTxC6wWYCZ1b9t4KrN//1hvd1n1svP9Hzq/f/3sc
j4GW/ztAy/8693jussS1sLCwsLCwsLCwsLD4F/EFkEmXCAAoAAA=

--YiEDa0DAkWCtVeE4--

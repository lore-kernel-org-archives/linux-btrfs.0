Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39811 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759567AbbBIIYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 03:24:11 -0500
Message-ID: <54D86EAC.3090803@cn.fujitsu.com>
Date: Mon, 9 Feb 2015 16:24:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <clm@fb.com>
Subject: Re: [PATCH 1/4] Btrfs-progs: add regression tests for sysfs contents
 during btrfs device management
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com> <1423465506-30934-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423465506-30934-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 1/4] Btrfs-progs: add regression tests for sysfs 
contents during btrfs device management
From: Anand Jain <anand.jain@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年02月09日 15:05
> This contains a series of btrfs device operations and at each operation
> the btrfs sysfs contents are logged.  This helps to check if the patch
> is affecting any of the btrfs sysfs contents.
>
> OR This script can be used to test the only the device operations.
>
> as of now there are 32 test cases
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   tests/test-btrfs-devmgt.sh | 863 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 863 insertions(+)
>   create mode 100755 tests/test-btrfs-devmgt.sh
>
> diff --git a/tests/test-btrfs-devmgt.sh b/tests/test-btrfs-devmgt.sh
> new file mode 100755
> index 0000000..2f75200
> --- /dev/null
> +++ b/tests/test-btrfs-devmgt.sh
> @@ -0,0 +1,863 @@
> +# * GNU General Public License v2. Copyright Oracle 2015
> +
> +
> +# Series of btrfs device operation test cases.
> +#
> +
> +# sysfs: test
> +# sysfs contents are taken at reasonable places (but you may disable it).
> +# So to compare with the next iteration with your kernel patch. so
> +# you can check for the sysfs changes by running diff of TMP_FILE(s)
> +
> +# Changelog:
> +# v1.0 init asj
> +
> +
> +		#When you change something related to device
> +		#remember to test on btrfs boot separately
> + #test0: btrfs boot test
> +
> +		#Replace:
> + #test1: raid1, replace normal
> + #test2: raid1, replace missing
> + #test3: NOP
> + #test4: raid1, replace missing, replace normal
> + #test5: raid1, replace dev2, replace dev1
> +
> +		#Add sprout, replace:
> + #test6: add sprout, replace seed
> + #test7: raid1 seed, add sprout, replace seed, replace sprout
> + #test8: 3 level nested seeds, add sprout, replace mid level seed
> + #test9: raid1, degraded seed mount, add sprout, replace missing, replace non missing seed
> + #test10: add sprout, replace sprout
> + #test11: raid1 seed, add sprout, replace sprout, replace sprout again
> + #test12: 3 level nested seeds, add sprout, replace sprout
> + #test13: degraded raid1 seed, add sprout, replace sprout
> +
> +		#Mount sprout, replace:
> + #test14: NOP
> + #test15: mount sprout, replace sprout
> + #test16: mount sprout, replace seed
> + #test17: Raid1, mount sprout, replace sprout
> + #test18: Raid1, mount sprout, replace seed
> + #test19: Raid1 degraded, mount sprout, replace sprout
> + #test20: Raid1 degraded, mount sprout, replace missing
> + #test21: 3 level nested seeds, mount sprout, replace mid level seed
> +
> +		#seed sprout test:
> + #test22: mount sprout, mount seed
> + #test23: clean, mount -o device sprout
> + #test24: raid1, mount sprout
> + #test25: clean, scan, mount sprout
> + #test26: raid1, clean, mount -o device sprout
> + #test26: raid1, clean, scan, mount sprout
> +
> +		#dev add del test:
> + #test27: dev add
> + #test28: dev del
> +
> +		#dev scan test:
> + #test29: scan mount
> + #test30: use -o mount
> +
> +		#subvol mount test:
> + #test31: mount, mount subvol
> +
> +		#remount test:
> + #test32: mount, remount
This tests are not even not bind to btrfs-progs.
They are kernel tests in fact.

So btrfs-progs isn't the best place for it.

Thanks,
Qu
> +
> +
> +
> +
> +# Devices are hard coded. sorry
> +


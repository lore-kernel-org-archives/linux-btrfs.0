From: "Gong, Zhipeng" <zhipeng.gong@intel.com>
Subject: btrfsctl exit with 1 when succeed
Date: Wed, 11 Nov 2009 14:16:24 +0800
Message-ID: <E88DD564E9DC5446A76B2B47C3BCCA150221B14DD3@pdsmsx503.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We'd like to use btrfsctl in a shell script, however, btrfsctl exit wit=
h 1 even if the operation is successful, which is opposite to the usual=
 shell command convention.
Why btrfsctl add this conversion in the end?
=A0=A0=A0=A0=A0=A0=A0=A0 if (ret)
=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0 exit(0);
=A0=A0=A0=A0=A0=A0=A0=A0 else
=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0 exit(1);

Thanks
Zhipeng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: What's the benefit of COW without checksum?
Date: Tue, 26 Jan 2010 15:44:53 +0800
Message-ID: <977a2be21001252344s2371aa8by1f68dfff186b3747@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
According to my understanding, COW in Btrfs services for 1) snapshots
capacities 2) keeping checksum consistent with FS data,
that's why nodatacow implies nodatasum. And COW will still happen for
snapshots even under 'nodatacow'.

So could you please tell me what can we get from COW if not computing
checksum (nodatasum)? That's to say, if some user decides to
disable checksum, do you think it's fine for him to just mount with
'nodatacow'? Or there's still some reason for him to use bare
'nodatasum'?

Thanks & Regards,
Zhu Yanhai

(Resent it again as the previous one was rejected by mailing list for
its contained HTML subpart)

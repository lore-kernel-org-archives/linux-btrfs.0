Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0164DC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 11:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD437204FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 11:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732284AbeLQLiu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:38:50 -0500
Received: from mout.gmx.net ([212.227.15.15]:45899 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732275AbeLQLit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 06:38:49 -0500
Received: from localhost ([94.79.149.170]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MMjgF-1gUkEj3MSN-008Yuo; Mon, 17
 Dec 2018 12:38:46 +0100
Message-ID: <1545046684.2140.29.camel@gmx.net>
Subject: Re: undelete files
From:   "Massimo B." <massimo.b@gmx.net>
To:     Laurent Lauden <laurent.lauden@laposte.net>,
        linux-btrfs@vger.kernel.org
In-Reply-To: <98a3ae94-d6ed-b7ba-34eb-61b9f2db33e8@laposte.net>
References: <98a3ae94-d6ed-b7ba-34eb-61b9f2db33e8@laposte.net>
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAA3NCSVQICAjb4U/gAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAABGUlEQVQYlUWQsUoDQRCGv71LjB7KSSBwwZCTgFhY2EYIHmJnZRMLo5AXUMRCBMHcE6iPoGBlINpoZXGVeQTFKqSxMgYtTBFcZw7EKfZn2Z2Z7//hr2ysZ+5tqFLmWKVaKKs0vWd9TJx2AibmoQcupj6CCZirqTgzA5hmsdtQWe5/xAREX7uJ3MLP9x4lyieNO5mcOxyM8HH79y/4Cdn9R3JDsts/uGO82yOMJf/ah1Y8tfQEIQt7Z7rCawtNiUpHFgYUdgTxgI1NAW6SvxoqWabbw0Bd5jpQibTNBC1F4nIMk2TWhTqIs+fSVpzfCsVR9eaiJf5W6mtWXK7O+vKR4nWkSYSuFbP4No3Ht6dpSN9pSMYmaXI1/usXT0FM3SoTKAAAAAAASUVORK5CYII=
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 17 Dec 2018 12:38:04 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.26.6 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ts+3olSoMp6kEdrwxId3eUskUENeApfZ9fu7jLsVXcKUUHLonbl
 LMjnLrcwYFykX/BReOnrGEcwmOx1tPJ79gDgaL+fkhS5Xr94SczVc8yrQ/qEn2C9oqndr3Z
 o8T7rm9Ntd4Us7rwZKeC2BnuVTaG3JdPZ3rbPXyvvBKYeX3v5Ri6HHdhpzm6wU2Y//8mGEM
 eoxS9jYVlXyZNMRmTKYFA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4zvii7wELXE=:nx3XTHXB0+EA+G7/waSDJw
 QWHoy6NovgY5ZNOg9crdproeNPO2I/i1YPwIQ1d23oOwAT/9Pm8crffRyp7mClXZ/5IVaptCl
 uRF0S5eD/mr69uqRzlus8ndhg4+k1kAwTCv6NRnoCkYuCX6A/T8pJ+QjfBTsxUttvYg4DO4CU
 A/3HC4IbWc1+OBM6e4WP4abKpsmZoUpsACBGmOCSvIPYyh6aWndceYP5qV4xXgki2W5PTiGHz
 zNC1z3Bmb2QUPD8SEM3a33wcX4FpDdmosdkgd19Y0xGi7txQb+JnFM+3K6dcY9dTeyJrDn5KS
 AAbqJT6Rdo3WQxeNJ/dTzxQIodl8BEgtIEH8oglsC3g28rk8FtMPxCeX36Y68hI7TvNfdQm+o
 ABOdIzP+bufUv8H2LqiKXKSMRtVb74uPTL8n0OPeIDmZhA5q1P7xfRfik04lWNrge3jPX73pH
 rteYBjqwT4hUp3u7tUssdr691V2bNwsHffWpAsz2zpd2DuveL2CdbbXzeRIWD9YuekzOi3s6O
 2dkI+eaWH79CDrIZHwnObMx+M2QI++X5A3uBapGDrtCJB7VbZmoxjLpv/MneNROM6rBGMdpRw
 16CXWyNvcODsX/Ncn2tegDWLRr5MbfwfxZNH5IIf/TXL6Bqd9Sgf+3Sfe1DCMQRyHZwjABMlJ
 QhuRk15m7C9lzN/fRtJ9AVpQ4nEQiYgvmOPzNP0KxB0xFVCdV7A+XsyXdrGx/5MGvT5ENgGxN
 +jQrq0Q7PvSoGJxTc19iQmyMOTHdcFeQ4X5F+KoFO0XbsR3iERD2rf0OHbFRKUuuhSBpcllX6
 VanCbCnkaPvK6ZuVFQImFloY1K2bC/YBYtj104IIgV14qXIy1OaTAkVyC4NF7guf66ggdxCXy
 GgiREMz+T+Rk6iQB4jX8tpj6g+5gpjHioSFHicKcs7nIWGEQH7lpdnoyyEimlF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I had a similar issue. On OpenSuse I deleted /.snapshots/ and was not aware that
/.snapshots/1/snapshot/ is the default subvolume representing my root file
system.
So I had no snapshot left, all ro subvolumes have been deleted before, and the
default subvolume had big parts deleted before I cancelled the rm -rfv. I kept a
copy of the STDOUT listing the deleted files and switched off the power of that
filesystem immediately, no sync or umount.
There have been no additional writes, so I was quite sure the data must still be
there.

I booted a live version of the OpenSuse TW. However btrfsprogs are missing the
important btrfs-find-root, so I compiled the progs from the very recent github
revision.

After I played with the btrfs restore and --path-regex I had no success, finding
some of the files that have been deleted.
I found a copy of the btrfs-undelete script and played with that:
https://gist.github.com/Changaco/45f8d171027ea2655d74

I learned how to traverse the root-ids to older generations, but the script
found absolutely none of the deleted files.
I modified the script to use btrfs-find-root -a which found some more root-ids
but still no success, for instance:

# btrfs-undelete /dev/mapper/_root "/@/.snapshots/1/snapshot/etc/cron.daily/1btrk.cron" /mnt/usb/rescue
Trying root 88866816... (329/332)
Trying root 66764800... (330/332)
Trying root 66600960... (331/332)
Trying root 60571648... (332/332)
Didn't find '@/.snapshots/1/snapshot/etc/cron.daily/1btrk.cron'

I did not trust the obscure --path-regex.

I also reproduced what the script does, using regular expressions like
'^/(|@(|/.snapshots(|/1(|/snapshot(|/etc(|/cron.daily(|/1btrbk.cron)))))))$'

However I did some btrfs restore --dry-run and grepped the known files myself,
until I found older root-ids containing almost all of the missing files with
meta-data. The snippets I like to share here:

# btrfs-find-root -a /dev/mapper/_root |grep Well |cut -d '(' -f 1 |awk '{print $3}' | while read -r rootid ; do echo "### rootid: $rootid"; btrfs restore -t $rootid -Dvi /dev/mapper/_root /mnt/usb/rescue/;done 2>/dev/null |grep -e "### rootid" -e "1btrbk.cron"

### rootid: 245530624
### rootid: 245022720
### rootid: 244760576
### rootid: 242139136
### rootid: 242892800
### rootid: 241942528
### rootid: 209518592
### rootid: 144097280
### rootid: 147816448
Restoring /mnt/usb/rescue/@/.snapshots/1/snapshot/etc/cron.daily/1btrbk.cron
### rootid: 123863040
Restoring /mnt/usb/rescue/@/.snapshots/1/snapshot/etc/cron.daily/1btrbk.cron

Best regards,
Massimo

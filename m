Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6572C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 06:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5097320882
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 06:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhb+b4Vf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5097320882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbeLGGny (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 01:43:54 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38843 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbeLGGnx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 01:43:53 -0500
Received: by mail-wr1-f49.google.com with SMTP id v13so2718656wrw.5
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 22:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+31/6zHy6AQzj8RcmAeWsztkhqk4l7s1WwueL05U9s=;
        b=fhb+b4VfTuKu2K6WKeHEkej9QEPpY10fY/XBxmIgtouVxsNsla4xGn9sNKIjAkgnUu
         ACxNzzVfWtJBEylwrioUhJfPUc6kOQUWqsAuscvivzkcltFGedJ/IMSnHYbgQQrOdUzL
         K4aOS2SXM8PFNkGZG3XjF47SyRP0F4Ga8tposuN6VNzMLVtmT9V40TPMhH+1Gn5G+Mdo
         S5MPmT3fP8Czj17BAzFT8OUP3D67hm79WXE4h1WCXHG/jCWnFr+n0G6lZfs0bBxolgbe
         8Mkub54kRb4XDZVrUkaKDLbQtLhvdvdthv3e3dv4F+2Rw2WVyYffPdOjSv5y6DtQHmYN
         Ob4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+31/6zHy6AQzj8RcmAeWsztkhqk4l7s1WwueL05U9s=;
        b=V1YsKa56+ojcNLxqFb5Aek4T6Da7BSBotrsEUMEnPsaOytZ/1re6iUjLLpOKq0KuHe
         VbF3uBilsJxEB+vDgdBPWzu6ewyRBe/04cOxQxEf0nhrQqtUyOhIJRg+x7q1Z/gRoGVt
         WzXsAjuAaPGHZH47Tz2zT1Ysg0pZdLhZSMrsmYCpccAmVIQoK5+zNhYxEwsddPj+I9FV
         4hPzgDyWYfR2g6/Iy9sXQyZtvu1SF/ycilYXS1HD5lHyCJeMZDJ/ktd7KldyOQsh2gYq
         hDW5wwj3RgISAvOuPL7uSLJJreBRdBmkMAlMOKqhddwskRvJR175Isjxn6IeArdYqmzI
         zKdQ==
X-Gm-Message-State: AA+aEWakrwQ8LH2l5r5GGJionzfNSxN3aLy22JCmja7/nU5LTJtoJPL/
        4/IcAMQplPppxULX354u649bvCU4a91tzTCOeRE=
X-Google-Smtp-Source: AFSGD/WB/GAuWRw+4itZluNQpuoAndU6IU+XzzA5gj+X3FJKfe5iPMgHdghDCNweU1kRl8IM97qh+7fbD1iHiXbl0Po=
X-Received: by 2002:adf:8c09:: with SMTP id z9mr740293wra.301.1544165030527;
 Thu, 06 Dec 2018 22:43:50 -0800 (PST)
MIME-Version: 1.0
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
 <CAJCQCtSiYk4RMRWRoaAFchzvinQ4tq1wC_Ru9d8gJWRsebvbTw@mail.gmail.com>
In-Reply-To: <CAJCQCtSiYk4RMRWRoaAFchzvinQ4tq1wC_Ru9d8gJWRsebvbTw@mail.gmail.com>
From:   Doni Crosby <doni.crosby1995@gmail.com>
Date:   Fri, 7 Dec 2018 01:43:38 -0500
Message-ID: <CAJkMDByx_H3xjJmN4gO+L0pxpkd7sWLTmTxRfNjUp06r8o3E7w@mail.gmail.com>
Subject: Re: System unable to mount partition after a power loss
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000001ec8ca057c68f0c7"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--0000000000001ec8ca057c68f0c7
Content-Type: text/plain; charset="UTF-8"

> This is qemu-kvm? What's the cache mode being used? It's possible the
> usual write guarantees are thwarted by VM caching.
Yes it is a proxmox host running the system so it is a qemu vm, I'm
unsure on the caching situation.

> Old version of progs, I suggest upgrading to 4.17.1 and run
I updated the progs to 4.17 and ran the following

btrfs insp dump-s -f /device/:
See attachment

btrfs rescue super -v /device/ (insp rescue super wasn't valid)
All Devices:
        Device: id = 1, name = /dev/vda1

Before Recovering:
        [All good supers]:
                device name = /dev/vda1
                superblock bytenr = 65536

                device name = /dev/vda1
                superblock bytenr = 67108864

                device name = /dev/vda1
                superblock bytenr = 274877906944

        [All bad supers]:

All supers are valid, no need to recover

btrfs check --mode=lowmem /dev/vda1:
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=3563210342400 item=120 parent
level=1 child level=1
ERROR: cannot open file system

mount -o ro,norecovery,usebackuproot /dev/vda1 /mnt:
Same dmesg output as before.
On Fri, Dec 7, 2018 at 12:56 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Dec 6, 2018 at 10:24 PM Doni Crosby <doni.crosby1995@gmail.com> wrote:
> >
> > All,
> >
> > I'm coming to you to see if there is a way to fix or at least recover
> > most of the data I have from a btrfs filesystem. The system went down
> > after both a breaker and the battery backup failed. I cannot currently
> > mount the system, with the following error from dmesg:
> >
> > Note: The vda1 is just the entire disk being passed from the VM host
> > to the VM it's not an actual true virtual block device
>
> This is qemu-kvm? What's the cache mode being used? It's possible the
> usual write guarantees are thwarted by VM caching.
>
>
>
> > btrfs check --recover also ends in a segmentation fault
>
> I'm not familiar with --recover option, the --repair option is flagged
> with a warning in the man page.
>            Warning
>            Do not use --repair unless you are advised to do so by a
> developer or an experienced user,
>
>
> > btrfs --version:
> > btrfs-progs v4.7.3
>
> Old version of progs, I suggest upgrading to 4.17.1 and run
>
> btrfs insp dump-s -f /device/
> btrfs insp rescue super -v /device/
> btrfs check --mode=lowmem /device/
>
> These are all read only commands. Please post output to the list,
> hopefully a developer will get around to looking at it.
>
> It is safe to try:
>
> mount -o ro,norecovery,usebackuproot /device/ /mnt/
>
> If that works, I suggest updating your backup while it's still
> possible in the meantime.
>
>
> --
> Chris Murphy

--0000000000001ec8ca057c68f0c7
Content-Type: text/plain; charset="US-ASCII"; name="btrfs-insp.txt"
Content-Disposition: attachment; filename="btrfs-insp.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_jpdnzc8e0>
X-Attachment-Id: f_jpdnzc8e0

c3VwZXJibG9jazogYnl0ZW5yPTY1NTM2LCBkZXZpY2U9L2Rldi92ZGExDQotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCmNzdW1fdHlwZSAg
ICAgICAgICAgICAgIDAgKGNyYzMyYykNCmNzdW1fc2l6ZSAgICAgICAgICAgICAgIDQNCmNzdW0g
ICAgICAgICAgICAgICAgICAgIDB4YmZhNmZkNzIgW21hdGNoXQ0KYnl0ZW5yICAgICAgICAgICAg
ICAgICAgNjU1MzYNCmZsYWdzICAgICAgICAgICAgICAgICAgIDB4MQ0KICAgICAgICAgICAgICAg
ICAgICAgICAgKCBXUklUVEVOICkNCm1hZ2ljICAgICAgICAgICAgICAgICAgIF9CSFJmU19NIFtt
YXRjaF0NCmZzaWQgICAgICAgICAgICAgICAgICAgIDdjNzZiYjA1LWIzZGMtNDgwNC1iZjU2LTg4
ZDAxMGEyMTRjNg0KbGFiZWwgICAgICAgICAgICAgICAgICAgQXJyYXkNCmdlbmVyYXRpb24gICAg
ICAgICAgICAgIDUxODQ2OTMNCnJvb3QgICAgICAgICAgICAgICAgICAgIDMxODAxMzQ0DQpzeXNf
YXJyYXlfc2l6ZSAgICAgICAgICAyMjYNCmNodW5rX3Jvb3RfZ2VuZXJhdGlvbiAgIDUxODM3MzQN
CnJvb3RfbGV2ZWwgICAgICAgICAgICAgIDENCmNodW5rX3Jvb3QgICAgICAgICAgICAgIDIwOTcx
NTIwDQpjaHVua19yb290X2xldmVsICAgICAgICAxDQpsb2dfcm9vdCAgICAgICAgICAgICAgICAw
DQpsb2dfcm9vdF90cmFuc2lkICAgICAgICAwDQpsb2dfcm9vdF9sZXZlbCAgICAgICAgICAwDQp0
b3RhbF9ieXRlcyAgICAgICAgICAgICAzMjAwMzk0NzczNzA4OA0KYnl0ZXNfdXNlZCAgICAgICAg
ICAgICAgNjY1Mjc3NjY0MDUxMg0Kc2VjdG9yc2l6ZSAgICAgICAgICAgICAgNDA5Ng0Kbm9kZXNp
emUgICAgICAgICAgICAgICAgMTYzODQNCmxlYWZzaXplIChkZXByZWNhdGVkKSAgICAgICAgICAg
MTYzODQNCnN0cmlwZXNpemUgICAgICAgICAgICAgIDQwOTYNCnJvb3RfZGlyICAgICAgICAgICAg
ICAgIDYNCm51bV9kZXZpY2VzICAgICAgICAgICAgIDENCmNvbXBhdF9mbGFncyAgICAgICAgICAg
IDB4MA0KY29tcGF0X3JvX2ZsYWdzICAgICAgICAgMHgwDQppbmNvbXBhdF9mbGFncyAgICAgICAg
ICAweDE2MQ0KICAgICAgICAgICAgICAgICAgICAgICAgKCBNSVhFRF9CQUNLUkVGIHwNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgQklHX01FVEFEQVRBIHwNCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgRVhURU5ERURfSVJFRiB8DQogICAgICAgICAgICAgICAgICAgICAgICAgIFNLSU5OWV9N
RVRBREFUQSApDQpjYWNoZV9nZW5lcmF0aW9uICAgICAgICA1MTg0NjkxDQp1dWlkX3RyZWVfZ2Vu
ZXJhdGlvbiAgICA1MTg0NjkxDQpkZXZfaXRlbS51dWlkICAgICAgICAgICBlMDU0MzMyNi1mNzZj
LTQ0MDktOThkYy05OGE3ODJhNzU0OTANCmRldl9pdGVtLmZzaWQgICAgICAgICAgIDdjNzZiYjA1
LWIzZGMtNDgwNC1iZjU2LTg4ZDAxMGEyMTRjNiBbbWF0Y2hdDQpkZXZfaXRlbS50eXBlICAgICAg
ICAgICAwDQpkZXZfaXRlbS50b3RhbF9ieXRlcyAgICAzMjAwMzk0NzczNzA4OA0KZGV2X2l0ZW0u
Ynl0ZXNfdXNlZCAgICAgNjc0NDIxMDE0NTI4MA0KZGV2X2l0ZW0uaW9fYWxpZ24gICAgICAgNDA5
Ng0KZGV2X2l0ZW0uaW9fd2lkdGggICAgICAgNDA5Ng0KZGV2X2l0ZW0uc2VjdG9yX3NpemUgICAg
NDA5Ng0KZGV2X2l0ZW0uZGV2aWQgICAgICAgICAgMQ0KZGV2X2l0ZW0uZGV2X2dyb3VwICAgICAg
MA0KZGV2X2l0ZW0uc2Vla19zcGVlZCAgICAgMA0KZGV2X2l0ZW0uYmFuZHdpZHRoICAgICAgMA0K
ZGV2X2l0ZW0uZ2VuZXJhdGlvbiAgICAgMA0Kc3lzX2NodW5rX2FycmF5WzIwNDhdOg0KICAgICAg
ICBpdGVtIDAga2V5IChGSVJTVF9DSFVOS19UUkVFIENIVU5LX0lURU0gMCkNCiAgICAgICAgICAg
ICAgICBsZW5ndGggNDE5NDMwNCBvd25lciAyIHN0cmlwZV9sZW4gNjU1MzYgdHlwZSBTWVNURU0N
CiAgICAgICAgICAgICAgICBpb19hbGlnbiA0MDk2IGlvX3dpZHRoIDQwOTYgc2VjdG9yX3NpemUg
NDA5Ng0KICAgICAgICAgICAgICAgIG51bV9zdHJpcGVzIDEgc3ViX3N0cmlwZXMgMA0KICAgICAg
ICAgICAgICAgICAgICAgICAgc3RyaXBlIDAgZGV2aWQgMSBvZmZzZXQgMA0KICAgICAgICAgICAg
ICAgICAgICAgICAgZGV2X3V1aWQgZTA1NDMzMjYtZjc2Yy00NDA5LTk4ZGMtOThhNzgyYTc1NDkw
DQogICAgICAgIGl0ZW0gMSBrZXkgKEZJUlNUX0NIVU5LX1RSRUUgQ0hVTktfSVRFTSAyMDk3MTUy
MCkNCiAgICAgICAgICAgICAgICBsZW5ndGggODM4ODYwOCBvd25lciAyIHN0cmlwZV9sZW4gNjU1
MzYgdHlwZSBTWVNURU18RFVQDQogICAgICAgICAgICAgICAgaW9fYWxpZ24gNjU1MzYgaW9fd2lk
dGggNjU1MzYgc2VjdG9yX3NpemUgNDA5Ng0KICAgICAgICAgICAgICAgIG51bV9zdHJpcGVzIDIg
c3ViX3N0cmlwZXMgMA0KICAgICAgICAgICAgICAgICAgICAgICAgc3RyaXBlIDAgZGV2aWQgMSBv
ZmZzZXQgMjA5NzE1MjANCiAgICAgICAgICAgICAgICAgICAgICAgIGRldl91dWlkIGUwNTQzMzI2
LWY3NmMtNDQwOS05OGRjLTk4YTc4MmE3NTQ5MA0KICAgICAgICAgICAgICAgICAgICAgICAgc3Ry
aXBlIDEgZGV2aWQgMSBvZmZzZXQgMjkzNjAxMjgNCiAgICAgICAgICAgICAgICAgICAgICAgIGRl
dl91dWlkIGUwNTQzMzI2LWY3NmMtNDQwOS05OGRjLTk4YTc4MmE3NTQ5MA0KYmFja3VwX3Jvb3Rz
WzRdOg0KICAgICAgICBiYWNrdXAgMDoNCiAgICAgICAgICAgICAgICBiYWNrdXBfdHJlZV9yb290
OiAgICAgICAzNTYzMTg5MDI2ODE2ICAgZ2VuOiA1MTg0NjkwICAgIGxldmVsOiAxDQogICAgICAg
ICAgICAgICAgYmFja3VwX2NodW5rX3Jvb3Q6ICAgICAgMjA5NzE1MjAgICAgICAgIGdlbjogNTE4
MzczNCAgICBsZXZlbDogMQ0KICAgICAgICAgICAgICAgIGJhY2t1cF9leHRlbnRfcm9vdDogICAg
IDM1NjMxODgyMjQwMDAgICBnZW46IDUxODQ2OTAgICAgbGV2ZWw6IDINCiAgICAgICAgICAgICAg
ICBiYWNrdXBfZnNfcm9vdDogICAgICAgICAzNTYzMTg3NDIxMTg0ICAgZ2VuOiA1MTg0NjkwICAg
IGxldmVsOiAyDQogICAgICAgICAgICAgICAgYmFja3VwX2Rldl9yb290OiAgICAgICAgNzQxMzI5
NjU2MjE3NiAgIGdlbjogNTE4MzczNCAgICBsZXZlbDogMQ0KICAgICAgICAgICAgICAgIGJhY2t1
cF9jc3VtX3Jvb3Q6ICAgICAgIDM1NjMxODc3MzI0ODAgICBnZW46IDUxODQ2OTAgICAgbGV2ZWw6
IDMNCiAgICAgICAgICAgICAgICBiYWNrdXBfdG90YWxfYnl0ZXM6ICAgICAzMjAwMzk0NzczNzA4
OA0KICAgICAgICAgICAgICAgIGJhY2t1cF9ieXRlc191c2VkOiAgICAgIDY2NTI3NzY2NDA1MTIN
CiAgICAgICAgICAgICAgICBiYWNrdXBfbnVtX2RldmljZXM6ICAgICAxDQoNCiAgICAgICAgYmFj
a3VwIDE6DQogICAgICAgICAgICAgICAgYmFja3VwX3RyZWVfcm9vdDogICAgICAgMzU2MzE5Njc5
MjgzMiAgIGdlbjogNTE4NDY5MSAgICBsZXZlbDogMQ0KICAgICAgICAgICAgICAgIGJhY2t1cF9j
aHVua19yb290OiAgICAgIDIwOTcxNTIwICAgICAgICBnZW46IDUxODM3MzQgICAgbGV2ZWw6IDEN
CiAgICAgICAgICAgICAgICBiYWNrdXBfZXh0ZW50X3Jvb3Q6ICAgICAzNTYzMTkzOTI1NjMyICAg
Z2VuOiA1MTg0NjkxICAgIGxldmVsOiAyDQogICAgICAgICAgICAgICAgYmFja3VwX2ZzX3Jvb3Q6
ICAgICAgICAgMzU2MzE5MDUwMTM3NiAgIGdlbjogNTE4NDY5MSAgICBsZXZlbDogMg0KICAgICAg
ICAgICAgICAgIGJhY2t1cF9kZXZfcm9vdDogICAgICAgIDc0MTMyOTY1NjIxNzYgICBnZW46IDUx
ODM3MzQgICAgbGV2ZWw6IDENCiAgICAgICAgICAgICAgICBiYWNrdXBfY3N1bV9yb290OiAgICAg
ICAzNTYzMTkwNjQ4ODMyICAgZ2VuOiA1MTg0NjkxICAgIGxldmVsOiAzDQogICAgICAgICAgICAg
ICAgYmFja3VwX3RvdGFsX2J5dGVzOiAgICAgMzIwMDM5NDc3MzcwODgNCiAgICAgICAgICAgICAg
ICBiYWNrdXBfYnl0ZXNfdXNlZDogICAgICA2NjUyNzc2NjQwNTEyDQogICAgICAgICAgICAgICAg
YmFja3VwX251bV9kZXZpY2VzOiAgICAgMQ0KDQogICAgICAgIGJhY2t1cCAyOg0KICAgICAgICAg
ICAgICAgIGJhY2t1cF90cmVlX3Jvb3Q6ICAgICAgIDM1NjMxODc3ODE2MzIgICBnZW46IDUxODQ2
ODggICAgbGV2ZWw6IDENCiAgICAgICAgICAgICAgICBiYWNrdXBfY2h1bmtfcm9vdDogICAgICAy
MDk3MTUyMCAgICAgICAgZ2VuOiA1MTgzNzM0ICAgIGxldmVsOiAxDQogICAgICAgICAgICAgICAg
YmFja3VwX2V4dGVudF9yb290OiAgICAgMzU2MzE4NTQ3MTQ4OCAgIGdlbjogNTE4NDY4OCAgICBs
ZXZlbDogMg0KICAgICAgICAgICAgICAgIGJhY2t1cF9mc19yb290OiAgICAgICAgIDM1NjMxNzky
NjE5NTIgICBnZW46IDUxODQ2ODggICAgbGV2ZWw6IDINCiAgICAgICAgICAgICAgICBiYWNrdXBf
ZGV2X3Jvb3Q6ICAgICAgICA3NDEzMjk2NTYyMTc2ICAgZ2VuOiA1MTgzNzM0ICAgIGxldmVsOiAx
DQogICAgICAgICAgICAgICAgYmFja3VwX2NzdW1fcm9vdDogICAgICAgMzU2MzE4MzczNDc4NCAg
IGdlbjogNTE4NDY4OCAgICBsZXZlbDogMw0KICAgICAgICAgICAgICAgIGJhY2t1cF90b3RhbF9i
eXRlczogICAgIDMyMDAzOTQ3NzM3MDg4DQogICAgICAgICAgICAgICAgYmFja3VwX2J5dGVzX3Vz
ZWQ6ICAgICAgNjY1Mjc3NjY0MDUxMg0KICAgICAgICAgICAgICAgIGJhY2t1cF9udW1fZGV2aWNl
czogICAgIDENCg0KICAgICAgICBiYWNrdXAgMzoNCiAgICAgICAgICAgICAgICBiYWNrdXBfdHJl
ZV9yb290OiAgICAgICAzNTYzMTg3NjE3NzkyICAgZ2VuOiA1MTg0Njg5ICAgIGxldmVsOiAxDQog
ICAgICAgICAgICAgICAgYmFja3VwX2NodW5rX3Jvb3Q6ICAgICAgMjA5NzE1MjAgICAgICAgIGdl
bjogNTE4MzczNCAgICBsZXZlbDogMQ0KICAgICAgICAgICAgICAgIGJhY2t1cF9leHRlbnRfcm9v
dDogICAgIDM1NjMxODYxNDMyMzIgICBnZW46IDUxODQ2ODkgICAgbGV2ZWw6IDINCiAgICAgICAg
ICAgICAgICBiYWNrdXBfZnNfcm9vdDogICAgICAgICAzNTYzMTgzODMzMDg4ICAgZ2VuOiA1MTg0
Njg5ICAgIGxldmVsOiAyDQogICAgICAgICAgICAgICAgYmFja3VwX2Rldl9yb290OiAgICAgICAg
NzQxMzI5NjU2MjE3NiAgIGdlbjogNTE4MzczNCAgICBsZXZlbDogMQ0KICAgICAgICAgICAgICAg
IGJhY2t1cF9jc3VtX3Jvb3Q6ICAgICAgIDM1NjMxODQ5NjM1ODQgICBnZW46IDUxODQ2ODkgICAg
bGV2ZWw6IDMNCiAgICAgICAgICAgICAgICBiYWNrdXBfdG90YWxfYnl0ZXM6ICAgICAzMjAwMzk0
NzczNzA4OA0KICAgICAgICAgICAgICAgIGJhY2t1cF9ieXRlc191c2VkOiAgICAgIDY2NTI3NzY2
NDA1MTINCiAgICAgICAgICAgICAgICBiYWNrdXBfbnVtX2RldmljZXM6ICAgICAx
--0000000000001ec8ca057c68f0c7--

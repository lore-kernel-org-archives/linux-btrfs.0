Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72632C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BA762086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 15:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="rf+ZGYBX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbeLSPla (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:41:30 -0500
Received: from mout.web.de ([212.227.15.3]:41271 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbeLSPl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 10:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1545234087;
        bh=656SOcRwXlZFJclbKT2NK5+75JFbyGNeQK3mCNh7Phs=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=rf+ZGYBXlxhY+r20EKvxk6v7okx4x6/c2REkdYo6HbmYLQZqe0hymVCnIHDRXw9yb
         JnQZkt2DCxTWUxEKC1db0YaUkSty5wpJBg8V/1elkWNhESrTv6KLvRbISUCWU4gl8a
         qsPYhTBGaQ5XPs6N+zXhDvwn6iP0/2ko4uXN8baE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [5.147.253.138] ([5.147.253.138]) by web-mail.web.de
 (3c-app-webde-bs26.server.lan [172.19.170.26]) (via HTTP); Wed, 19 Dec 2018
 16:41:27 +0100
MIME-Version: 1.0
Message-ID: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
From:   devzero@web.de
To:     linux-btrfs@vger.kernel.org
Subject: compress-force not really forcing compression?
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 19 Dec 2018 16:41:27 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:y3zSJKKVjOwkhff+aYFlwItogwWYYdSdn7Fvpwd1K2e8Lx8+9ODYaw7Ly1Q+2zcDHQpjT
 1nWMV4r+Pt8UmqmhLkFN7i/6uEh7UhaV8mWEH1NE5PeBII9Ud+KO6i9Tse9uKiJ4WOtnQVIobDHR
 Mm2e2YQiHfY8TgTebgP0JmjM9Ka7u5dBxvV6J1dP5dXtlJQElQXmcBq0I+hfLepj6weF7uG48z4t
 hre4ag9B1tAHFWo7vEBdbVLoW91alZMqzT8IJUFXBscf4JOLXZJNcp0og5Dt2vny5A1CDCJiuTT+
 iQ=
X-UI-Out-Filterresults: notjunk:1;V03:K0:XouHyAFdfNo=:+SqHkvLYEzfHmxBHcLpkQ4
 jXAIWtxM9KU+aw5E/2zc9V3wtgQ0AaOxPWDcNGkNDe0bKK1/EFSxsve+Hrn1pGL2Ags1W++W8
 7WOD6FlDcGnbu+SONQgbOCWESNAkceAVEPmq3gE7kNB1JKEABmwc617KwEvChhmJMHl3rMt4N
 HRnh58rKEMEMKCoE+J5vb7KAxh8DambIKCZ+q+zK9vLkR63Rc9YbP+F90rBm8OtPWf7CcAB0b
 gBq6I46EwxTss8j5HHjo7eIaXH69TUemxX1yfRl84SaP7Shli7JKRJwMevtCihjDCW7Ub4f4W
 W8d3BwD0LJ6b1jQMZldmw+jCcOE0Wx8u3ePowxI0yAWlaXx2IiTU+c5N6J0X9hp1mnStiXE37
 YZfZAeLshl1Nm8+ILKVRhizETGCyQikc6ypVqRA99vY5Uu6ytN7ePO9Ow7KeiHWCLgxRhy2q9
 mK2Xl43E8KwERRk9cLQ/8C6WHi4DJFSD7ONrEyRqkd67oxLDAp/wV0Rc0GQcE0bMiLb7HWoQw
 ReNaZqSozVGlsGK2Cuj3ldXnFV6Cp3MpD+oaxECwgbkQuOhRLnVVGLYgUAJkdqOzQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

does compress-force really force compression?

for me (found via compsize - see https://github.com/kilobyte/compsize/issues/24 )  it looks it is problably forcing compression check for every block of a file (while compress= makes btrfs skip compression check after first block) and if some block is incompressible, apparently it's being stored uncompressed.

so, the documentation is probably telling misleading information and should be fixed!?

roland



https://btrfs.wiki.kernel.org/index.php/Compression#What_happens_to_incompressible_files.3F

What happens to incompressible files?

There is a simple decision logic: if the first portion of data being compressed is not smaller than the original, the compression of the file is disabled -- unless the filesystem is mounted with -o compress-force. In that case it'll be compressed always regardless of the compressibility of the file. This is not optimal and subject to optimizations and further development. 




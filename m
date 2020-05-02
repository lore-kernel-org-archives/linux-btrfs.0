Return-Path: <SRS0=372E=6Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A824C3A5A9
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 May 2020 14:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A64A24953
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 May 2020 14:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="uqFCkoUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgEBOzs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 May 2020 10:55:48 -0400
Received: from mail4.protonmail.ch ([185.70.40.27]:46823 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEBOzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 May 2020 10:55:48 -0400
Date:   Sat, 02 May 2020 14:55:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1588431345;
        bh=twfoZnGLAqPMSRPux4uyRcgfg5HNuyW34AgPfFhmD9M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=uqFCkoUDjd5vIXb5KdKYZff/bOm9iPhlhRGkzVQnkFlfzAt7TWS7Sm8+BNoTNKHq2
         qEjNz28hr1CL5NEw4wGTZY5MsXehN04JrpFzfpADPqmaPOS7wrPdJr+nMEqgfKt3ij
         C3KYnDk53cVM41qaF0bG0CKURgWxQfqocKP2fS4k=
To:     Chris Murphy <lists@colorremedies.com>
From:   Nouts <nouts@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Reply-To: Nouts <nouts@protonmail.com>
Subject: Re: Troubleshoot help needed - RAID1 not mounting : failed to read block groups
Message-ID: <ZL8K9EyQa7EnOmd3WjfSsNFy8hYbikAq4lO6CTK1vc-HoXoqpY9CKKcYd2xFCwEDvry2aLuZvbwK91-2_J-Zu6tDL6sovvr4jRIATnhmyMQ=@protonmail.com>
In-Reply-To: <CAJCQCtQ=hwE-wwPXEw_r+VOe36zsHYmpx7updj4JOMmQqQeM8w@mail.gmail.com>
References: <EvtqVyP9SQGLLtX4spGcgzbLaK45gh3h00n6u9QU19nuQi6g13oqfZf6dmGm-N8Rdd2ZCFl7zOeEBXRc_Whom2KYJA1eDUSQxgZPZgmI7Dc=@protonmail.com>
 <5oMc__tPC-OFYhHTtUghYtHMzySzDXlSlYC_S5_WjIFiA8eXfvsSxQpfaglOag0sNz7qtvMUzhCqdRzBOMokxeo2dFrfkWrLbBmmuWvME5s=@protonmail.com>
 <CAJCQCtT0mSYvN7FeCavsmKP9j_69JmZ0JdGz8ommhqag=GiM=Q@mail.gmail.com>
 <NmjvBWGDb0a1ZnPep0UnBmeFG4uSUMrxyiYDCir6RRsMyZzizVtCH_8tdd6Y_glmPbbusrKtVBCgGvV7Cc5UFCDqcvJ1PTgWi87x-0FacQ4=@protonmail.com>
 <CAJCQCtRWdovSOQd8r7YzxsQa4fxT9feB_R-nvG7BjvB-u1m2ew@mail.gmail.com>
 <XzvzKWYVgWGlgX7GSa5XGfQcMuM4od6BMpG63kC2X3thsAfl0i__swcKuMF3TcdiInqnifyiphevLoacMdYlEn7YDqj8JDLKFaZRZsoQx1Q=@protonmail.com>
 <CAJCQCtQ=hwE-wwPXEw_r+VOe36zsHYmpx7updj4JOMmQqQeM8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For the record, I ran check and check --repair with the new btrfs-progs. Bo=
th returned this error :

Opening filesystem to check...
ERROR: child eb corrupted: parent bytenr=3D5923702292480 item=3D2 parent le=
vel=3D2 child level=3D0
ERROR: failed to read block groups: Input/output error
ERROR: cannot open file system

I'm gonna wipe the drive and restore a backup as I've lost hope recovering =
and can't wait any longer.
Thanks a lot for your help !

Nouts

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Thursday, April 30, 2020 9:18 PM, Chris Murphy <lists@colorremedies.com>=
 wrote:

> On Thu, Apr 30, 2020 at 1:05 PM Nouts nouts@protonmail.com wrote:
>
> > Here is the dump --follow : https://pastebin.com/yx13mDfB
> > Sadly, none of "mount" worked.
>
> Yep. I can't tell from the check error or the dump output, whether
> it's worth trying chunk recover again with the latest progs, or check
> with --repair. But either of those makes changes to the file system,
> so best to get advice from a developer first and in the meantime
> refresh backups.
>
> I don't know that a newer kernel will help in this case, because even
> the latest progs complains. And the output from check doesn't give
> enough information to know what to try next or if it's hopeless.
>
> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------
>
> Chris Murphy



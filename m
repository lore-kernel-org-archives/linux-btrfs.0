Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4FDC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 04:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6BF820861
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 04:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="ccg2b9h6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfAVEye (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 23:54:34 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:39431 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfAVEye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 23:54:34 -0500
Received: by mail-lf1-f44.google.com with SMTP id n18so17073715lfh.6
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 20:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CYznHYxl+A2o3FehfC2M6S/ZZC4D0h8N2abcj/POc6g=;
        b=ccg2b9h68cvC+l7rBJtlDdG2kJPvJpukMD85LfoSTs/Lvz/QMAPOoYl6MHIuLLpriA
         8765hpeLws4t1Wk6mXYzShBtbMO6SRcwi5d93RjkBDKcYQKooLYVcIE725vpx++VBtez
         U4ce8W8aO7UBYFUIaHNbOEPW+4zk0sgsZfVZCMpaHlTuJ+rTgPvJ3jnGuEFYXB4FhXQK
         7KnSrRNb/B50EqhUOrwNZ2lmIfnr1DfsgwUCfkK8dCErewXGcjtj6OLvs2MQCDO/pP1n
         vr+Y6UsdPqP+KCha/qPEyniDZS+V9IQNm8rfgm2gRoSHQ+MAF4vlqE5kvNVj06jnVhsJ
         UwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CYznHYxl+A2o3FehfC2M6S/ZZC4D0h8N2abcj/POc6g=;
        b=FcowmoKEJEqnwi4BSugt7pZJxjtUenhsugE/Iqdw2B4j/FUJnVO2RBajVdK0z3EIcO
         HlpQXQonObRFD+JqhuYy3ay6rKYcPt2tGl1QCBef9Sum7iDyQ+f279Bi0sEog9UTMEpC
         C/W0yNLSePHOwXFJBXI8gjypAfN3Rt6JbF4C6ucQ/784DICbO2VIUqZIbTldyMOmN2zo
         WkSCvYcwnN+Y/oMLj5LC9q1nkwyWFQ1mbToYZl2TPF7FjrRvsUxomofObcboiIYtcG0K
         jn8v4iL85zMDsOT4te9Umuzfhkw4x5yP7IGnz2yj2LPI9y+S9G73Q9915nwPUacMN8cV
         5bVg==
X-Gm-Message-State: AJcUukcCDmrMdkqKpaAKkN/ERgsul+JegeCcGeYbS9DcA4Z3Rvr/SMWl
        ow0lEtW4nDx988kjziwvxfovbs0RMj1jDiqCHqUq7PC1zBk=
X-Google-Smtp-Source: ALg8bN4Wu5HZ01dmvhc41/LV5UOqA8O1953yswnSRklcqfsOSJl0ClJ8ScLx1qbKrUEUGejSDxTqo63VLWskna9UjyY=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr19094731lfg.89.1548132871327;
 Mon, 21 Jan 2019 20:54:31 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au> <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 21 Jan 2019 21:54:19 -0700
Message-ID: <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Dennis K <dennisk@netspace.net.au>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 21, 2019 at 3:23 PM Chris Murphy <lists@colorremedies.com> wrot=
e:



> If <parent> has a UUID of 54321, I expect that <subvol> must have
> Parent UUID of 54321, or the send command should fail.

OK I think the following is a reproducible bug.

# btrfs sub create 1
# btrfs sub create 2
# touch 1/one
# touch 2/two
# btrfs sub snap -r 1 1.ro1
# btrfs sub snap -r 2 2.ro1
# touch 1/oneone
# touch 2/twotwo
# btrfs sub snap -r 1 1.ro2
# btrfs sub snap -r 2 2.ro2
# btrfs send 1.ro1 | ssh chris@fnuc.local "sudo btrfs receive /srv/scratch/=
"
At subvol 1.ro1
At subvol 1.ro1
# btrfs send 2.ro1 | ssh chris@fnuc.local "sudo btrfs receive /srv/scratch/=
"
At subvol 2.ro1
At subvol 2.ro1
# btrfs send -p 1.ro1 2.ro2 | ssh chris@fnuc.local "sudo btrfs receive
/srv/scratch/"
At subvol 2.ro2
At snapshot 2.ro2
#

I expect the last command to fail because 1.ro1 is not the parent of
2.ro2. The command completes, and 2.ro2 is on the destination, and at
least in this simple example it contains the expected files. However
'btrfs show' indicates that the "parent UUID" of 2.ro2 is the "UUID"
of 1.ro1, which is definitely wrong. So it's a legit bug, not just a
cosmetic problem due to lack of error checking.

$ ls -l 1.ro1
total 0
-rw-rw-r--. 1 chris chris 0 Jan 21 21:41 one
$ ls -l 2.ro1
total 0
-rw-rw-r--. 1 chris chris 0 Jan 21 21:41 two
$ ls -l 2.ro2
total 0
-rw-rw-r--. 1 chris chris 0 Jan 21 21:41 two
-rw-rw-r--. 1 chris chris 0 Jan 21 21:41 twotwo
$


 =EE=82=A2 fnuc.local =EE=82=B0 chris =EE=82=B0 / =EE=82=B1 srv =EE=82=B1 s=
cratch =EE=82=B0 sudo btrfs sub show 1.ro1
scratch/1.ro1
    Name:             1.ro1
    UUID:             eb0bb290-3f7d-d34d-94c3-1ed9da96f2fa
    Parent UUID:         -
    Received UUID:         b965a4b6-e77d-714b-af0e-83e15e734fd5
    Creation time:         2019-01-21 21:43:04 -0700
    Subvolume ID:         3107
    Generation:         25788
    Gen at creation:     25782
    Parent ID:         2039
    Top level ID:         2039
    Flags:             readonly
    Snapshot(s):
                scratch/2.ro2
 =EE=82=A2 fnuc.local =EE=82=B0 chris =EE=82=B0 / =EE=82=B1 srv =EE=82=B1 s=
cratch =EE=82=B0 sudo btrfs sub show 1.ro2
ERROR: cannot find real path for '1.ro2': No such file or directory
 =EE=82=A2 fnuc.local =EE=82=B0 chris =EE=82=B0 / =EE=82=B1 srv =EE=82=B1 s=
cratch =EE=82=B0 sudo btrfs sub show 2.ro1
scratch/2.ro1
    Name:             2.ro1
    UUID:             ce0d762a-d4ea-6448-aa71-1573d70fe60e
    Parent UUID:         -
    Received UUID:         d382f4f9-23c9-394e-852d-ecbe9a95fa75
    Creation time:         2019-01-21 21:43:15 -0700
    Subvolume ID:         3108
    Generation:         25786
    Gen at creation:     25785
    Parent ID:         2039
    Top level ID:         2039
    Flags:             readonly
    Snapshot(s):
 =EE=82=A2 fnuc.local =EE=82=B0 chris =EE=82=B0 / =EE=82=B1 srv =EE=82=B1 s=
cratch =EE=82=B0 sudo btrfs sub show 2.ro2
scratch/2.ro2
    Name:             2.ro2
    UUID:             165a4a66-0600-3b49-80aa-edae8fd850d9
    Parent UUID:         eb0bb290-3f7d-d34d-94c3-1ed9da96f2fa
    Received UUID:         b8343d21-882f-bf47-ac61-b59e53b126a4
    Creation time:         2019-01-21 21:43:38 -0700
    Subvolume ID:         3109
    Generation:         25789
    Gen at creation:     25788
    Parent ID:         2039
    Top level ID:         2039
    Flags:             readonly
    Snapshot(s):
 =EE=82=A2 fnuc.local =EE=82=B0 chris =EE=82=B0 / =EE=82=B1 srv =EE=82=B1 s=
cratch =EE=82=B0





--=20
Chris Murphy

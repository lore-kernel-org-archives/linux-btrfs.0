Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45083 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2F0Ajs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 20:39:48 -0400
Received: by dady13 with SMTP id y13so622353dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 17:39:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK43AWtSfiQ2qWjMEAWVagh0yPkpdpqmw69bvph9sMvdCgtbPg@mail.gmail.com>
References: <CAK43AWvAeKzhR2pdpTxMLA=66BK6ErLBCVzPB3Cyy7X+_EjZEA@mail.gmail.com>
	<CANZ96zW4BX4jXP+ZBj2380QJ3gB_yOWa6VgFn9gHBeDq1qc4Lg@mail.gmail.com>
	<CAK43AWthZ5Y3Rjkp6EduXO17J7Paz7SHYj_qOUbpwHyVQ_JKRQ@mail.gmail.com>
	<CAK43AWtSfiQ2qWjMEAWVagh0yPkpdpqmw69bvph9sMvdCgtbPg@mail.gmail.com>
Date: Wed, 27 Jun 2012 07:39:47 +0700
Message-ID: <CAG1y0seEMWWHjGCdK2_umNDWfG0jhOCWZnzCKbKWWcsuAdqGkg@mail.gmail.com>
Subject: Re: System Policy for Filenames
From: "Fajar A. Nugraha" <list@fajar.net>
To: Aaron Peterson <myusualnickname@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 1:28 AM, Aaron Peterson
<myusualnickname@gmail.com> wrote:
> Billy,
>
> Thank you! I will look into FUSE.
>
> Ultimately, I want my / to be mounted with these rules,  I will need a
> boot loader to be able to handle it.

Try looking at how ubuntu live cd works. Last time I check, it can use
unionfs-fuse as "/" to make the read-only cd media appear "writable"
live session. Something similar should be applicable to your needs.

>  I am wondering if filesystem software has hooks for AppArmor or
> SELinux, or some other Linux Security Module would be appropriated to
> add to filesystem code?

Not that I know of.

-- 
Fajar

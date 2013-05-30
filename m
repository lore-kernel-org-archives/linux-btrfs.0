Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:47523 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3E3SGv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 14:06:51 -0400
Received: by mail-vb0-f41.google.com with SMTP id p14so396432vbm.14
        for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 11:06:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
References: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
Date: Thu, 30 May 2013 20:06:50 +0200
Message-ID: <CAFvQSYS1odBm3+ttcuQCZuxmWuVfUkCatQw1bAG_B_uTJVmCmw@mail.gmail.com>
Subject: Re: Btrfsck errors (fs tree 565 refs 125 not found) - how serious
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

I am able to induce the btrfsck errors I experienced using a synthetic
workload on a fresh filesystem with linux-3.10.0.rc2.
However as filing the bug-report would take quite some time (uploading
512mb trace-files, writing a short read-me, ...) I wonder whether this
is an issue woth of reporting, or maybe just caused by an outdated
version of btrfsck (I am using
btrfs-progs-0.20.rc1.20130308git704a08c-1).

Regards, Clemens

> fs tree 565 refs 125 not found
>         unresolved ref root 807 dir 813347 index 277 namelen 39 name
> snapshot_1368273601_2013-05-11_14:00:01 error 600
  ......

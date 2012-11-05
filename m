Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33120 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964824Ab2KEXWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 18:22:37 -0500
Date: Tue, 6 Nov 2012 00:22:26 +0100
From: David Sterba <dave@jikos.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: "Fajar A. Nugraha" <list@fajar.net>, Hugo Mills <hugo@carfax.org.uk>,
        cwillu <cwillu@cwillu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and
 subvols
Message-ID: <20121105232226.GQ3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
 <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
 <20121101223253.GA28864@carfax.org.uk>
 <CAG1y0scEreHgQwFBCABRwbF1_mQaibgPwLBKUOLJD7kV2HL7JA@mail.gmail.com>
 <509769C0.2040508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <509769C0.2040508@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 05, 2012 at 03:24:48PM +0800, Anand Jain wrote:
>  feature    xattr     btrfs-kernel-way
>  [1]         No        Yes
>  [2]         No        Yes
>  [3]         Yes       No
> 
> 
>  [1]. Ability to read subvol label without mount

It is possible to read it offline, one can traverse the data structures
the same way as from kernel, ie root_tree -> subovlume fs_tree -> root
directory item -> xattr item.

>  [2]. Full-ability to log and track the property
>       when it is modified

What is expected to happen when the label changes? I understand that
somebody may change the xattr value silently, but let's say this is
changed through kernel -- do you intend to prohibit any changes or issue
some notification or whatever?

>  [3]. risk-free patch ?

No patch is risk free :) but yes, xattrs use an established and tested
infrastruture.

davdi

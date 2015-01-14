Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49334 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbbANATi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:19:38 -0500
From: Josef Bacik <jbacik@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "merlijn@wizzup.org" <merlijn@wizzup.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
Date: Wed, 14 Jan 2015 00:19:34 +0000
Message-ID: <84w0q01m3b5b1hbckrg0uobw.1421194772147@email.android.com>
References: <1421187619-24936-1-git-send-email-jbacik@fb.com>,<20150114001341.GP3685@twin.jikos.cz>
In-Reply-To: <20150114001341.GP3685@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a regression and I don't have the setup to figure out how to make it work for both.  If somebody else can fix it quickly then fine but if not it needs to be reverted.  Thanks,

Josef

David Sterba <dsterba@suse.cz> wrote:


On Tue, Jan 13, 2015 at 05:20:19PM -0500, Josef Bacik wrote:
> This reverts commit c2691f807ddd2c6b261c5707f6838a45d9275390 as it breaks
> backtracing on actual glibc environments.

This is to support musl libc. If it does not work then the test is wrong
and should be fixed. CCed the author.

https://urldefense.proofpoint.com/v1/url?u=http://openwall.com/lists/musl/2013/03/29/13&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=Dm8rcPdQBMJJL%2B383z6ziMVmnPg9BLbftawEBBcsq6E%3D%0A&s=86bd77631ddae58dca51fe780a120817815205620ff4fe920d578ce1f335ad5e

Seems that there's no ifdef way to find out the libc used.

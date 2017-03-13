Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20840 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdCMKzq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 06:55:46 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jbacik@fb.com" <jbacik@fb.com>, "clm@fb.com" <clm@fb.com>,
        "dsterba@suse.com" <dsterba@suse.com>
Subject: RE: [PATCH 00/17] fs, btrfs refcount conversions
Date: Mon, 13 Mar 2017 10:54:53 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C581FB@IRSMSX102.ger.corp.intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
 <20170309160234.GH14605@twin.jikos.cz>
In-Reply-To: <20170309160234.GH14605@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Fri, Mar 03, 2017 at 10:55:09AM +0200, Elena Reshetova wrote:
> > Now when new refcount_t type and API are finally merged
> > (see include/linux/refcount.h), the following
> > patches convert various refcounters in the btrfs filesystem from atomic_t
> > to refcount_t. By doing this we prevent intentional or accidental
> > underflows or overflows that can led to use-after-free vulnerabilities.
> >
> > The below patches are fully independent and can be cherry-picked separately.
> > Since we convert all kernel subsystems in the same fashion, resulting
> > in about 300 patches, we have to group them for sending at least in some
> > fashion to be manageable. Please excuse the long cc list.
> 
> Thanks, the patchset looks good to me, I'm going to add it to the 4.12 queue.

Thank you very much!

> 
> > These patches have been tested with xfstests by running btrfs-related tests.
> > btrfs debug was enabled, warns on refcount errors, too. No output related to
> > refcount errors produced. However, the following errors were during the run:
> >  * tests btrfs/078, btrfs/114, btrfs/115, no errors anywhere in dmesg, but
> >  process hangs. They all seem to be around qgroup, sometimes error visible
> >  such as qgroup scan failed -4 before it blocks, but not always.
> >  * test btrfs/104 dmesg has additional error output:
> >  BTRFS warning (device vdc): qgroup 258 reserved space underflow, have: 0,
> >  to free: 4096
> >  I tried looking at the code on what causes the failure, but could not figure
> >  it out. It doesn't seem to be related to any refcount changes at least IMO.
> >
> > The above test failures are hard for me to understand and interpreted, but
> > they don't seem to relate to refcount conversions.
> 
> I don't think they're related to the refcount updates so we'll address
> them.

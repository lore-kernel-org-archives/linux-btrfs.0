From: Berke Durak <berke.durak@gmail.com>
Subject: Re: Minimum device size of 256 MiB?
Date: Fri, 11 May 2012 17:22:00 -0400
Message-ID: <CAALTfKDgw_z6D5am9Tv4FEmd-F3L1OPQLxga2nbAdpKXEtoq3w@mail.gmail.com>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
	<20120511205032.GV21964@eightyeight.xmission.com>
	<CAALTfKCMUCjT0J2BfDZ1PwWQ9QKjCDk8WfE3tthdoq0Neg3PUA@mail.gmail.com>
	<CAALTfKDbXDUDq-vfsgEvzH+in9u11YckMMUGV=Mi7HKLMHeQSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAALTfKDbXDUDq-vfsgEvzH+in9u11YckMMUGV=Mi7HKLMHeQSQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately nothing guarantees that the footprint of the filesystem
will stay bounded.

In other words, even if the number of blocks occupied by the
filesystem at any time is less than the capacity of the physical
device backing the sparse device, the total number of blocks ever
occupied by the filesystem since its creation may exceed the capacity
of the physical device.
-- 
Berke Durak

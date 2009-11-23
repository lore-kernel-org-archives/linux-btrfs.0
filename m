From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A file cloned with "cp --reflink" different from the original
 one?
Date: Mon, 23 Nov 2009 10:52:13 -0500
Message-ID: <20091123155213.GE15294@think>
References: <119341710911230208j5e60734cvf09cfcacd86ba9f6@mail.gmail.com>
 <4B0A8FC1.4050208@draigBrady.com>
 <119341710911230614h10d7071dq3700cdf39e0c28fb@mail.gmail.com>
 <4B0AAE8A.2020900@draigBrady.com>
 <119341710911230750j10502561xac71cfd37ad9a649@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>,
	bug-coreutils@gnu.org, linux-btrfs@vger.kernel.org
To: Jian Lin <lj@linjian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <119341710911230750j10502561xac71cfd37ad9a649@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2009 at 11:50:47PM +0800, Jian Lin wrote:
> Thanks. I will try the new version soon.

Note that you'll have to reclone the files, the new version won't fix
the old clone I'm afraid.

-chris

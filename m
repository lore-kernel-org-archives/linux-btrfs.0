From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Problems Implementing Snappy Patches
Date: Thu, 16 Feb 2012 18:10:44 -0600
Message-ID: <CAKcLGm-bwEEHJ6UihN3Ov7Y5E=kYWEtU7qYbLKY7aJmBjZNy4A@mail.gmail.com>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
	<4F3C6495.60906@cn.fujitsu.com>
	<20120216131535.GB1046@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Li Zefan <lizf@cn.fujitsu.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>, andi@firstfloor.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216131535.GB1046@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Just to add another data point, I built Chris Mason's 'snappy' branch
from git.kernel.org as-is (a 3.2.0 kernel plus the snappy patches)
with no additional patches.

This 3.2.0 snappy kernel also exhibits the problem copying the kernel
sources to a snappy-compressed partition.

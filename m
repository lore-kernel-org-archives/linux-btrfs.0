From: "K. Richard Pixley" <rich@noir.com>
Subject: btrfsctl returns bad exit status
Date: Fri, 23 Jul 2010 13:04:40 -0700
Message-ID: <4C49F5D8.50803@noir.com>
References: <4C47513D.1070902@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C47513D.1070902@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

Using btrfsctl from ubuntu maverick, (built and running on 
ubuntu-10.04), I get:

rich@eisenhower> btrfsctl -s snap1 /home || echo failed
operation complete
Btrfs Btrfs v0.19
failed
rich@eisenhower> ls -las snap1
total 4
4 drwxr-xr-x 1 root    root    32 2010-07-20 18:25 .
0 drwxr-xr-x 1 rich    rich  1324 2010-07-21 12:47 ..
0 drwxr-xr-x 1 checker build   22 2010-07-20 18:21 checker
0 drwxr-xr-x 1 rich    rich  1322 2010-07-21 12:44 rich
0 drwxr-xr-x 1 root    root    36 2010-07-21 10:47 za-cb

This would seem to indicate a non-zero exit status despite the fact that 
the snapshotting operation appears to have succeeded.  This makes it 
impossible to programmatically check whether a snapshot was created 
successfully or not as I will need to explicitly discard the exit status 
from btrfsctl.

I get the same results when built from git, except that it identifies 
itself as "v0.19-16-g075587c".

I would expect that btrfsctl would return zero exit status when it was 
capable of doing what it was asked and non-zero exit status only when it 
could not.

--rich

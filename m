From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs and 1 billion small files
Date: Tue, 08 May 2012 16:31:02 +1000
Message-ID: <4FA8BDA6.2070105@csamuel.org>
References: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it> <7802030.zmTeQQDGHD@bursa01> <9EC89864-505F-4821-90F9-389B8C65C4F2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9EC89864-505F-4821-90F9-389B8C65C4F2@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/12 20:06, Boyd Waters wrote:

> Use a directory hierarchy. Even if the filesystem handles a
> flat structure effectively, userspace programs will choke on
> tens of thousands of files in a single directory. For example
> 'ls' will try to lexically sort its output (very slowly) unless
> given the command-line option not to do so.

In my experience it's not so much that lexical sorting that kills you
but the default -F option which gets set for users these days, that
results in ls doing an lstat() on every file to work out if it's an
executable, directory, symlink, etc to modify how it displays it to you.

For instance on one of our HPC systems here we've a user with over
200,000 files in one directory.  It takes about 4 seconds for \ls
whereas \ls -F takes, well I can't tell you because it was still running
after 53 minutes (strace confirmed it was still lstat()ing) when I
killed it..

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

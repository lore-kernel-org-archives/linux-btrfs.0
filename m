From: Ravi Pinjala <ravi@p-static.net>
Subject: Replacing corrupted files/directories
Date: Thu, 2 Dec 2010 19:25:09 -0800
Message-ID: <AANLkTimKQ17g7hZrS0-AVxCyhyaLumWCa11Aq1vf+c9_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a recommended way to replace a corrupted file or directory on
btrfs? The use case I'm thinking of is handling filesystem corruption
by restoring only the corrupted files from backup. For a corrupted
file, it seems like deleting the file and replacing it with the copy
from the backup works, but I don't know if this is necessarily the
best way - the nature of copy-on-write means that there's still
corrupt data lying around on the filesystem, right? And for
directories, it's tricky, because (afaik) there's no way to delete a
directory without first walking it; not good if it's corrupted.

I think this is probably also relevant to something like Ceph or CRFS,
where redundancy exists, but isn't managed by btrfs directly.

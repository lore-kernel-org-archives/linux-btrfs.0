From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Fri, 14 Oct 2011 07:17:44 +0200
Message-ID: <CAJ1PRSk0BVoYw89C0RYejbRF-4QdrKkA_J94Kf+Y7r-u=w+aHA@mail.gmail.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just a idea: I don't know if btrfs works like that or not but idea
would be that b-tree filesystem should be able to "loose" or "discard"
branches be removing a node. Cut a tree node and branches will fall
off - and get overwrited as empty space sometime in future (just like
during data deletion).
If subvolume is filesystem in filesystem (don't know to what extend
this is true in btrfs) then sub-filesystem could be re-formated but
severing it links to its branches.
Reason for this if of course fast and not io costly deletion of large
number of files.

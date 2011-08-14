From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: unlink directory with files (rm -d)
Date: Sun, 14 Aug 2011 16:18:15 +0200
Message-ID: <CAJ1PRSkvi52kpppLumFMTfLPOU5uxHRBZ+ci8o0qbydyNg9MAw@mail.gmail.com>
References: <CAJ1PRS=9obyg-FRq=V6pZ7J=tccYA_UXWvNzF-6SaywL6rBY9g@mail.gmail.com>
	<CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
	<20110814110304.1537a2a3@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110814110304.1537a2a3@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

Not in all cases you can plan and predict where there will be need for
deleting large number of files. Also subvolumes are difficult to
maintain, not to mention still quite buggy.

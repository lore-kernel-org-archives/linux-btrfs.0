From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 4 May 2009 18:24:21 +0200
Message-ID: <20090504162421.GC13777@cip.informatik.uni-erlangen.de>
References: <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com> <2a31deca0905040916s43b60cf3xdc56d365b5c1d233@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0905040916s43b60cf3xdc56d365b5c1d233@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Andrey,

> As far as I understand, VMware already ships this "gold image" feature
> (as they call it) for Windows environments and claims it to be very
> efficient.

they call it ,,thin or shallow clones'' and ship it with desktop
virtualization (one vm per thinclient user) and for VMware lab manager.
Looking at the website content, it also revealed that VMware will have a
similiar feature for their workhorse ,,esx server'' in the upcoming
release, however my point still stands. Ship out a service pack for
windows and you 1.5 Gbyte of modified data that is not deduped. Because
that is a once in VMs life opportunity.

        Thomas

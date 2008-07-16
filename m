From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Re: QA suite plans
Date: Wed, 16 Jul 2008 16:22:16 +0300
Message-ID: <3da3b5b40807160622l1f7fe447q3c40219cdae3b18@mail.gmail.com>
References: <3da3b5b40807160139w4b8e3474te113980d0086ba9c@mail.gmail.com>
	 <3da3b5b40807160206h1e07033fu3fba59fd5edd7aa1@mail.gmail.com>
	 <20080716120540.GH30311@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080716120540.GH30311@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ok, cool. If the torture suite is a bunch of scripts, that is probably
something I can help with. I don't know what's the contribute policy
for this project, but if contributors are welcome I would like to
start a wiki page to gather test suite ideas, and I'd start writing
scripts to execute the tests and report back results

A bit intro about myself: I come from a "system engineering"
background. I've been introduced to Linux around 10 years ago. I'm an
RHCE, and currently work as a system engineer, integrating solutions
and consulting on them. I have been involved with the Fedora
community.

Action Items:
- How do I get access to create a wiki page
- Any instructions on checking out the code and building it ?
- I'm planning on using a VM for testing, any specific VMs recommended
(VirtualBox?)

Thanks

On Wed, Jul 16, 2008 at 3:05 PM, Josef Bacik <jbacik@redhat.com> wrote:
> On Wed, Jul 16, 2008 at 12:06:00PM +0300, Ahmed Kamal wrote:
>> Hi Team,
>> I have been following the btrfs project since Chris announced it last
>> year. I am happy to see v1.0 is planned in Q4. This is awesome, we can
>> finally get something like ZFS on Linux. The project pace is nothing
>> short of amazing. Thank you :)
>>
>> I notice the plans contain "QA suite".
>> I would like to ask if there are any written plans for this QA suite yet ?
>> Is the suite going to be kernel code, or is it basically going to be a
>> set of scripts using btrfs userspace commands for regression testing ?
>
> AFAIK its going to be alot like the xfs stuff, where its just a bunch of scripts
> to test for regressions.  So stuff to test the subvol/snapshotting stuff, and
> then other scripts to test the normal filesystem aspects of btrfs.  Thanks,
>
> Josef
>

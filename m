Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:41468 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbaKTCIZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 21:08:25 -0500
Message-ID: <546D4D14.3060706@pobox.com>
Date: Wed, 19 Nov 2014 18:08:20 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com>	<pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>	<546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <pan$338ee$938a2625$869a26d$19fb9c42@cox.net>
In-Reply-To: <pan$338ee$938a2625$869a26d$19fb9c42@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/19/2014 04:25 PM, Duncan wrote:
> Most often, however, it's at resume, not original startup, which is
> understandable as state at resume doesn't match state at suspend/
> hibernate.  The irritating thing, as previously discussed, is when one
> device takes long enough to come back that mdraid or btrfs drops it out,
> generally forcing the reboot I was trying to avoid with the suspend/
> hibernate in the first place, along with a re-add and resync (for mdraid)
> or a scrub (for btrfs raid).

If you want a practical solution you might want to look at 
http://underdog.soruceforge.net (my project, shameless plug). The actual 
user context return isn't in there but I use the project to build 
initramfs images into all my kernels.

[DISCLAIMER: The cryptsetup and LUKS stuff is rock solid but the mdadm 
incremental build stuff is very rough and so lightly untested]

You could easily add a drive preheat code block (spin up and status 
check all drives with pause and repeat function) as a preamble function 
that could/would safely take place before any glance is made towards the 
resume stage.

extemporaneous example::

--- snip ---
cat <<'EOT' >>/opt/underdog/utility/preheat.mod
#!/bin/bash
# ROOT_COMMANDS+=( commands your preheat needs )
UNDERDOG+=( init.d/preheat )
EOT

cat <<'EOT' >>/opt/underdog/prototype/init.d/preheat
#!/bin/bash
function __preamble_preheat() {
whatever logic you need
return 0
}
__preamble_funcs+=( [preheat]=__preamble_preheat )
EOT
--- snip ---

install underdog, paste the above into a shell once. edit 
/opt/underdog/prototype/init.d/preamble to put whatever logic in you need.

Follow the instructions in /opt/underdog/README.txt for making the 
initramfs image or, as I do, build the initramfs into the kernel image.

The preamble will be run in the resultant /init script before the swap 
partitions are submitted for attempted resume.

(The system does support complexity like resuming from a swap partition 
inside an LVM/LV built over a LUKS encrypted media expanse, or just a 
plain laptop with one plain partitioned disk, with zero changes to the 
necessary default config.)

-- Rob.




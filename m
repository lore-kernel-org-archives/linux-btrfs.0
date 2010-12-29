From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: [PATCH] x86: hpet: Fix HPET timer + NMI watchdog panic
Date: Wed, 29 Dec 2010 09:57:05 +0800
Message-ID: <4D1A9571.4030604@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mingo@redhat.com, tglx@linutronix.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

HPET doesn't use timer_interrupt() as interrupt handler now. So count of
HPET interrupt isn't recorded in per_cpu(irq_stat, cpu).irq0_irqs. This
confuses NMI watchdog when using HPET as tick device.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

---
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 55e4de6..cca94f2 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -12,6 +12,9 @@ typedef struct {
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
 #endif
+#ifdef CONFIG_HPET_TIMER
+	unsigned int hpet_timer_irqs;
+#endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
 	unsigned int apic_irq_work_irqs;
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index c90041c..cdb38d9 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -80,8 +80,15 @@ static inline int mce_in_progress(void)
  */
 static inline unsigned int get_timer_irqs(int cpu)
 {
-	return per_cpu(irq_stat, cpu).apic_timer_irqs +
+	unsigned int irqs; 
+#ifdef CONFIG_HPET_TIMER
+	irqs = per_cpu(irq_stat, cpu).hpet_timer_irqs;
+#else
+	irqs = 0;
+#endif
+	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
+	return irqs;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4ff5968..b536474c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -517,6 +517,7 @@ static irqreturn_t hpet_interrupt_handler(int irq, void *data)
 	struct hpet_dev *dev = (struct hpet_dev *)data;
 	struct clock_event_device *hevt = &dev->evt;
 
+	inc_irq_stat(hpet_timer_irqs);
 	if (!hevt->event_handler) {
 		printk(KERN_INFO "Spurious HPET timer interrupt on HPET timer %d\n",
 				dev->num);
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index fb5cc5e1..2098c56 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -56,7 +56,7 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 
 /*
- * Default timer interrupt handler for PIT/HPET
+ * Default timer interrupt handler for PIT
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {

